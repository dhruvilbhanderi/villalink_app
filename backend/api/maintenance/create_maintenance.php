<?php
require_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $user_id = $input['user_id'] ?? '';
    $amount = $input['amount'] ?? '';
    $due_date = $input['due_date'] ?? '';
    
    if (empty($user_id) || empty($amount) || empty($due_date)) {
        echo json_encode(['success' => false, 'message' => 'All fields required']);
        exit;
    }
    
    $query = "INSERT INTO maintenance (user_id, amount, due_date) VALUES (?, ?, ?)";
    $stmt = $db->prepare($query);
    
    if ($stmt->execute([$user_id, $amount, $due_date])) {
        echo json_encode(['success' => true, 'message' => 'Maintenance record created successfully']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Failed to create maintenance record']);
    }
}
?>