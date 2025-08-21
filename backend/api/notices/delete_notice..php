<?php
require_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $notice_id = $input['notice_id'] ?? '';
    $user_id = $input['user_id'] ?? '';
    
    if (empty($notice_id)) {
        echo json_encode(['success' => false, 'message' => 'Notice ID required']);
        exit;
    }
    
    // Check if user is president or created the notice
    $check_query = "SELECT created_by FROM notices WHERE id = ?";
    $check_stmt = $db->prepare($check_query);
    $check_stmt->bindParam(1, $notice_id);
    $check_stmt->execute();
    
    if ($check_stmt->rowCount() == 0) {
        echo json_encode(['success' => false, 'message' => 'Notice not found']);
        exit;
    }
    
    $notice = $check_stmt->fetch(PDO::FETCH_ASSOC);
    
    // Check if user has permission
    $user_query = "SELECT user_type FROM users WHERE id = ?";
    $user_stmt = $db->prepare($user_query);
    $user_stmt->bindParam(1, $user_id);
    $user_stmt->execute();
    $user = $user_stmt->fetch(PDO::FETCH_ASSOC);
    
    if ($user['user_type'] != 'president' && $notice['created_by'] != $user_id) {
        echo json_encode(['success' => false, 'message' => 'Permission denied']);
        exit;
    }
    
    $delete_query = "DELETE FROM notices WHERE id = ?";
    $delete_stmt = $db->prepare($delete_query);
    
    if ($delete_stmt->execute([$notice_id])) {
        echo json_encode(['success' => true, 'message' => 'Notice deleted successfully']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Failed to delete notice']);
    }
}
?>