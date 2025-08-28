<?php
session_start();

// Replace with your actual database credentials
$host = 'localhost';
$db   = '/docker/db/my_database';
$user = 'your_db_user';
$pass = 'your_db_password';

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim($_POST['username'] ?? '');
    $password = $_POST['password'] ?? '';

    if ($username && $password) {
        $mysqli = new mysqli($host, $user, $pass, $db);

        if ($mysqli->connect_error) {
            die('Database connection failed.');
        }

        $stmt = $mysqli->prepare('SELECT id, password_hash FROM users WHERE username = ?');
        $stmt->bind_param('s', $username);
        $stmt->execute();
        $stmt->store_result();

        if ($stmt->num_rows === 1) {
            $stmt->bind_result($user_id, $password_hash);
            $stmt->fetch();

            if (password_verify($password, $password_hash)) {
                $_SESSION['user_id'] = $user_id;
                $_SESSION['username'] = $username;
                header('Location: dashboard.php');
                exit;
            } else {
                $error = 'Invalid username or password.';
            }
        } else {
            $error = 'Invalid username or password.';
        }

        $stmt->close();
        $mysqli->close();
    } else {
        $error = 'Please enter both username and password.';
    }
}
?>

<!DOCTYPE html>
<html lang="en">
    <link rel="stylesheet" href="../css/styles.css">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
</head>
<body>
<div class="login-container">
    <h2>Login</h2>
    <?php if ($error): ?>
        <p class="error"><?= htmlspecialchars($error) ?></p>
    <?php endif; ?>
    <form method="post" action="login.php" autocomplete="off">
        <div>
            <label for="username">Username:</label><br>
            <input type="text" name="username" id="username" required autofocus>
        </div>
        <div>
            <label for="password">Password:</label><br>
            <input type="password" name="password" id="password" required>
        </div>
        <div>
            <button type="submit">Login</button>
        </div>
    </form>
</div>
</body>
</html>