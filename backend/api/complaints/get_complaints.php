<?php
require_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $user_id = $_GET['user_id'] ?? '';
    $user_type = $_GET['user_type'] ?? '';
    
    if ($user_type == 'president') {
        $query = "SELECT c.*, u.name as created_by_name, u.flat_number FROM complaints c 
                  LEFT JOIN users u ON c.created_by = u.id 
                  ORDER BY c.created_at DESC";
        $stmt = $db->prepare($query);
        $stmt->execute();
    } else {
        $query = "SELECT c.*, u.name as created_by_name FROM complaints c 
                  LEFT JOIN users u ON c.created_by = u.id 
                  WHERE c.created_by = ? ORDER BY c.created_at DESC";
        $stmt = $db->prepare($query);
        $stmt->bindParam(1, $user_id);
        $stmt->execute();
    }
    
    $complaints = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        'success' => true,
        'complaints' => $complaints
    ]);
}
?>