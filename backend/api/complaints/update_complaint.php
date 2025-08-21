<?php
require_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $complaint_id = $input['complaint_id'] ?? '';
    $status = $input['status'] ?? '';
    
    if (empty($complaint_id) || empty($status)) {
        echo json_encode(['success' => false, 'message' => 'Complaint ID and status required']);
        exit;
    }
    
    $query = "UPDATE complaints SET status = ? WHERE id = ?";
    $stmt = $db->prepare($query);
    
    if ($stmt->execute([$status, $complaint_id])) {
        echo json_encode(['success' => true, 'message' => 'Complaint status updated successfully']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Failed to update complaint status']);
    }
}
?>