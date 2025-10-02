<?php
header('Content-Type: application/json; charset=UTF-8');

require_once '../../config/database.php'; 

$database = new Database();
$db = $database->getConnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);

    $email = $input['email'] ?? '';
    $password = $input['password'] ?? '';

    if (empty($email) || empty($password)) {
        echo json_encode(['success' => false, 'message' => 'Email and password required']);
        exit;
    }

    $query = "SELECT id, name, email, phone, flat_number, user_type, is_active, password 
              FROM users WHERE email = ?";
    $stmt = $db->prepare($query);
    $stmt->bindParam(1, $email);
    $stmt->execute();

    if ($stmt->rowCount() > 0) {
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if (password_verify($password, $row['password'])) {
            // Check if user is active (presidents are always active, members need to be activated)
            if ($row['user_type'] === 'member' && !$row['is_active']) {
                echo json_encode([
                    'success' => false, 
                    'message' => 'Your account is not activated. Please contact the president for activation.'
                ]);
                exit;
            }
            
            unset($row['password']);
            echo json_encode([
                'success' => true,
                'message' => 'Login successful',
                'user' => $row
            ]);
        } else {
            echo json_encode(['success' => false, 'message' => 'Invalid credentials']);
        }
    } else {
        echo json_encode(['success' => false, 'message' => 'User not found']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid request method']);
}
