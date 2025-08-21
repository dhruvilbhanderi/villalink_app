<?php
require_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $user_id = $_GET['user_id'] ?? '';
    $user_type = $_GET['user_type'] ?? '';
    
    if ($user_type == 'president') {
        $query = "SELECT m.*, u.name as user_name, u.flat_number FROM maintenance m 
                  LEFT JOIN users u ON m.user_id = u.id 
                  ORDER BY m.due_date DESC";
        $stmt = $db->prepare($query);
        $stmt->execute();
    } else {
        $query = "SELECT * FROM maintenance WHERE user_id = ? ORDER BY due_date DESC";
        $stmt = $db->prepare($query);
        $stmt->bindParam(1, $user_id);
        $stmt->execute();
    }
    
    $maintenance = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        'success' => true,
        'maintenance' => $maintenance
    ]);
}
?>