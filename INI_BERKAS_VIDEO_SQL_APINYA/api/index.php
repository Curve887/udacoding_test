<?php
/* Handle CORS */

// Specify domains from which requests are allowed
header('Access-Control-Allow-Origin: *');

// Specify which request methods are allowed
header('Access-Control-Allow-Methods: PUT, GET, POST, DELETE, OPTIONS');

// Additional headers which may be sent along with the CORS request
header('Access-Control-Allow-Headers: X-Requested-With,Authorization,Content-Type');

// Set the age to 1 day to improve speed/caching.
header('Access-Control-Max-Age: 86400');

// Exit early so the page isn't fully loaded for options requests
if (strtolower($_SERVER['REQUEST_METHOD']) == 'options') {
    exit();
}
// Set Content type
header('Content-Type: application/json');

$db = new mysqli('localhost', 'root', '', 'library');
// Periksa koneksi
if ($db->connect_error) {
    die("Connection failed: " . $db->connect_error);
}

// Health check
if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    if ($_GET['action'] == 'health') {
        echo json_encode(['status' => 'ok']);
        exit;
    }
    if ($_GET['action'] == 'is_borrowed') {
        $book_id = $_GET['book_id'];
        $query = <<<SQL
            SELECT id_library, book_id, book_title, borrow_date, return_date
            FROM borrow
            WHERE book_id = ?
        SQL;
        error_log($book_id);
        $stmt = $db->prepare($query);
        $stmt->bind_param("s", $book_id);
        $stmt->execute();
        $stmt->store_result();
        $stmt->bind_result($id_library, $book_id, $book_title, $borrow_date, $return_date);
        $result = $stmt->fetch();
        error_log($result);
        if ($result) {
            echo json_encode(['status' => 'success', 'is_borrowed' => true, 'id_library' => $id_library, 'book_id' => $book_id, 'book_title' => $book_title, 'borrow_date' => $borrow_date, 'return_date' => $return_date]);
        } else {
            echo json_encode(['status' => 'success', 'is_borrowed' => false, 'id_library' => '', 'book_id' => (int) $book_id, 'book_title' => '', 'borrow_date' => '', 'return_date' => '']);
        }
    }

    if ($_GET["action"] == 'my_books') {
        $id_library = $_GET['id_library'];
        $query = <<<SQL
            SELECT id_library, book_id, book_title, borrow_date, return_date
            FROM borrow
            WHERE id_library = ?
        SQL;
        $stmt = $db->prepare($query);
        $stmt->bind_param("s", $id_library);
        $stmt->execute();
        $stmt->store_result();
        $stmt->bind_result($id_library, $book_id, $book_title, $borrow_date, $return_date);
        $books = [];
        while ($stmt->fetch()) {
            $books[] = [
                'id_library' => $id_library,
                'book_id' => $book_id,
                'book_title' => $book_title,
                'borrow_date' => $borrow_date,
                'return_date' => $return_date,
                'is_borrowed' => true
            ];
        }
        echo json_encode(['status' => 'success', 'books' => $books]);
    }
    exit;
}

// Register
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Mendapatkan body request
    $body = file_get_contents('php://input');
    
    // Mengecek jika body request kosong atau tidak valid
    if (empty($body)) {
        http_response_code(400);
        echo json_encode(['status' => 'error', 'message' => 'No data received']);
        exit;
    }

    // Decode JSON
    $body_json = json_decode($body);

    // Mengecek apakah JSON berhasil didekode
    if ($body_json === null) {
        http_response_code(400);
        echo json_encode(['status' => 'error', 'message' => 'Invalid JSON']);
        exit;
    }

    // Ambil action dari body_json dengan pengecekan
    if (isset($body_json->action)) {
        $action = $body_json->action;

        if ($action == 'register') {
            $email = $body_json->email;
            $name = $body_json->name;
            $password = $body_json->password;
            $hashed_password = password_hash($password, PASSWORD_DEFAULT);
            $id_library = rand(1000, 9999) . '-' . rand(1000, 9999) . '-' . rand(1000, 9999);
            $date = new DateTime();
            $created_at = $date->format('Y-m-d H:i:s');
            $query = <<<SQL
                INSERT INTO account (id_library, name, email, password_hash, created_at)
                VALUES (?, ?, ?, ?, ?)
            SQL;
            $stmt = $db->prepare($query);
            $stmt->bind_param("sssss", $id_library, $name, $email, $hashed_password, $created_at);
            $result = $stmt->execute();
            if ($result) {
                echo json_encode(['status' => 'success', 'id_library' => $id_library]);
            } else {
                http_response_code(500);
                echo json_encode(['status' => 'error']);
            }
        } else if ($action == "login") {
            $id_library = $body_json->id_library;
            $password = $body_json->password;
            $query = <<<SQL
                SELECT id_library, name, email, password_hash
                FROM account
                WHERE id_library = ?
            SQL;
            $stmt = $db->prepare($query);
            $stmt->bind_param("s", $id_library);
            $stmt->execute();
            $stmt->store_result();
            $stmt->bind_result($id_library, $name, $email, $password_hash);
            if ($stmt->fetch()) {
                if (password_verify($password, $password_hash)) {
                    $session_id = $id_library . '-' . bin2hex(random_bytes(16));
                    $_SESSION['session_id'] = $session_id;
                    echo json_encode(['status' => 'success', 'session_id' => $session_id, 'id_library' => $id_library]);
                } else {
                    http_response_code(401);
                    echo json_encode(['status' => 'error', 'message' => 'Invalid email or password']);
                }
            } else {
                http_response_code(401);
                echo json_encode(['status' => 'error', 'message' => 'Invalid email or password']);
            }
        } else if ($action == "borrow") {
            $book_id = $body_json->book_id;
            $id_library = $body_json->id_library;
            $book_title = $body_json->book_title;
            $date = new DateTime();
            $borrow_date = $body_json->borrow_date;
            $borrow_date_formatted = date('Y-m-d H:i:s', strtotime($borrow_date));
            $return_date = $body_json->return_date;
            $return_date_formatted = date('Y-m-d H:i:s', strtotime($return_date));
            $query = <<<SQL
                INSERT INTO borrow (id_library, book_id, book_title, borrow_date, return_date)
                VALUES (?, ?, ?, ?, ?)
            SQL;
            $stmt = $db->prepare($query);
            $stmt->bind_param("sssss", $id_library, $book_id, $book_title, $borrow_date_formatted, $return_date_formatted);
            $result = $stmt->execute();
            if ($result) {
                echo json_encode(['status' => 'success']);
            } else {
                http_response_code(500);
                echo json_encode(['status' => 'error']);
            }
        } else if ($action === "return") {
            $book_id = $body_json->book_id;
            $id_library = $body_json->id_library;
            $query = <<<SQL
                DELETE FROM borrow
                WHERE book_id = ? AND id_library = ?
            SQL;
            $stmt = $db->prepare($query);
            $stmt->bind_param("ss", $book_id, $id_library);
            $result = $stmt->execute();
            if ($result) {
                echo json_encode(['status' => 'success']);
            } else {
                http_response_code(500);
                echo json_encode(['status' => 'error']);
            }
        } else {
            http_response_code(400);
            echo json_encode(['status' => 'error', 'message' => 'Invalid action']);
        }
    } else {
        http_response_code(400);
        echo json_encode(['status' => 'error', 'message' => 'Missing action']);
    }
}

exit;
