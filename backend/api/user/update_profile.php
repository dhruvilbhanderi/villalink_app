<?php
require_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $user_id = $input['user_id'] ?? '';
    $name = $input['name'] ?? '';
    $phone = $input['phone'] ?? '';
    $flat_number = $input['flat_number'] ?? '';
    $current_password = $input['current_password'] ?? '';
    $new_password = $input['new_password'] ?? '';

    if (empty($user_id) || empty($name)) {
        echo json_encode(['success' => false, 'message' => 'User ID and name required']);
        exit;
    }

    // ✅ First, update profile fields
    $query = "UPDATE users SET name = ?, phone = ?, flat_number = ? WHERE id = ?";
    $stmt = $db->prepare($query);
    $stmt->execute([$name, $phone, $flat_number, $user_id]);

    // ✅ If password change requested
    if (!empty($current_password) && !empty($new_password)) {
        // Get current user
        $queryPwd = "SELECT password FROM users WHERE id = ?";
        $stmtPwd = $db->prepare($queryPwd);
        $stmtPwd->execute([$user_id]);
        $row = $stmtPwd->fetch(PDO::FETCH_ASSOC);

        if ($row && password_verify($current_password, $row['password'])) {
            // Hash and update new password
            $hashedPassword = password_hash($new_password, PASSWORD_BCRYPT);
            $updatePwd = "UPDATE users SET password = ? WHERE id = ?";
            $stmtUpdate = $db->prepare($updatePwd);

            if ($stmtUpdate->execute([$hashedPassword, $user_id])) {
                echo json_encode(['success' => true, 'message' => 'Profile and password updated successfully']);
                exit;
            } else {
                echo json_encode(['success' => false, 'message' => 'Failed to update password']);
                exit;
            }
        } else {
            echo json_encode(['success' => false, 'message' => 'Current password is incorrect']);
            exit;
        }
    }

    echo json_encode(['success' => true, 'message' => 'Profile updated successfully']);
}
?>
