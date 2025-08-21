<?php
require_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $title = $input['title'] ?? '';
    $description = $input['description'] ?? '';
    $created_by = $input['created_by'] ?? '';
    
    if (empty($title) || empty($description)) {
        echo json_encode(['success' => false, 'message' => 'Title and description required']);
        exit;
    }
    
    $query = "INSERT INTO complaints (title, description, created_by) VALUES (?, ?, ?)";
    $stmt = $db->prepare($query);
    
    if ($stmt->execute([$title, $description, $created_by])) {
        echo json_encode(['success' => true, 'message' => 'Complaint submitted successfully']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Failed to submit complaint']);
    }
}
?>