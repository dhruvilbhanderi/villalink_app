<?php
require_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $query = "SELECT n.*, u.name as created_by_name FROM notices n 
              LEFT JOIN users u ON n.created_by = u.id 
              ORDER BY n.created_at DESC";
    $stmt = $db->prepare($query);
    $stmt->execute();
    
    $notices = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        'success' => true,
        'notices' => $notices
    ]);
}
?>