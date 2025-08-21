<?php
require_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $maintenance_id = $input['maintenance_id'] ?? '';
    $status = $input['status'] ?? '';
    
    if (empty($maintenance_id) || empty($status)) {
        echo json_encode(['success' => false, 'message' => 'Maintenance ID and status required']);
        exit;
    }
    
    $query = "UPDATE maintenance SET status = ? WHERE id = ?";
    $stmt = $db->prepare($query);
    
    if ($stmt->execute([$status, $maintenance_id])) {
        echo json_encode(['success' => true, 'message' => 'Payment updated successfully']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Failed to update payment']);
    }
}
?>