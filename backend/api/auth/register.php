<?php
require_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $name = $input['name'] ?? '';
    $email = $input['email'] ?? '';
    $password = $input['password'] ?? '';
    $phone = $input['phone'] ?? '';
    $flat_number = $input['flat_number'] ?? '';
    $user_type = 'member'; // Default to member
    
    if (empty($name) || empty($email) || empty($password)) {
        echo json_encode(['success' => false, 'message' => 'Name, email and password required']);
        exit;
    }
    
    // Check if email already exists
    $check_query = "SELECT id FROM users WHERE email = ?";
    $check_stmt = $db->prepare($check_query);
    $check_stmt->bindParam(1, $email);
    $check_stmt->execute();
    
    if ($check_stmt->rowCount() > 0) {
        echo json_encode(['success' => false, 'message' => 'Email already exists']);
        exit;
    }
    
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);
    
    $query = "INSERT INTO users (name, email, password, phone, flat_number, user_type, is_active) VALUES (?, ?, ?, ?, ?, ?, FALSE)";
    $stmt = $db->prepare($query);
    
    if ($stmt->execute([$name, $email, $hashed_password, $phone, $flat_number, $user_type])) {
        echo json_encode(['success' => true, 'message' => 'Registration successful']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Registration failed']);
    }
}
?>