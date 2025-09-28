<?php
header('Content-Type: application/json; charset=utf-8');

// Allow CORS for dev — remove or lock down for production
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: POST, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Accept');
    exit;
}
header('Access-Control-Allow-Origin: *');

require_once '../../config/database.php'; // adjust path if needed

$database = new Database();
$db = $database->getConnection();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
    exit;
}

// Read JSON body
$input = json_decode(file_get_contents('php://input'), true);

$complaint_id = $input['complaint_id'] ?? null;

if (empty($complaint_id)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'complaint_id is required']);
    exit;
}

// optionally validate integer
$complaint_id = intval($complaint_id);
if ($complaint_id <= 0) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Invalid complaint_id']);
    exit;
}

try {
    // Optional: check if complaint exists
    $checkSql = "SELECT id FROM complaints WHERE id = ?";
    $checkStmt = $db->prepare($checkSql);
    $checkStmt->execute([$complaint_id]);
    $exists = $checkStmt->fetchColumn();

    if (!$exists) {
        http_response_code(404);
        echo json_encode(['success' => false, 'message' => 'Complaint not found']);
        exit;
    }

    // Delete (hard delete). If you want soft-delete, update status instead.
    $sql = "DELETE FROM complaints WHERE id = ?";
    $stmt = $db->prepare($sql);
    $ok = $stmt->execute([$complaint_id]);

    if ($ok && $stmt->rowCount() > 0) {
        echo json_encode(['success' => true, 'message' => 'Complaint deleted successfully']);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Failed to delete complaint']);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
