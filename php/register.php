<?php
// Start session
session_start();

// Handle Registration Submission
$errors = [];
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Validation
    $username = trim($_POST['username'] ?? '');
    $password = $_POST['password'] ?? '';
    $confirm_password = $_POST['confirm_password'] ?? '';

    if (empty($username)) {
        $errors[] = 'Username is required.';
    }
    if (empty($password)) {
        $errors[] = 'Password is required.';
    }
    if ($password !== $confirm_password) {
        $errors[] = 'Passwords do not match.';
    }

    // If no errors, save user (example: save to file, replace with DB in production)
    if (!$errors) {
        $usersFile = __DIR__ . '/users.txt';
        $userData = $username . ':' . password_hash($password, PASSWORD_DEFAULT) . PHP_EOL;
        file_put_contents($usersFile, $userData, FILE_APPEND);
        $_SESSION['username'] = $username;
        header('Location: /pages/dashboard.html');
        exit;
    }
}
?>

<!DOCTYPE html>
<html lang="en">
    <link rel="stylesheet" href="../css/styles.css">
<head>
    <meta charset="UTF-8">
    <title>Register - CRM Template</title>
</head>
<body>
<div class="container">
    <h2>Register</h2>
    <?php if ($errors): ?>
        <div class="error">
            <?php foreach ($errors as $error) echo htmlspecialchars($error) . '<br>'; ?>
        </div>
    <?php endif; ?>
    <form method="post" action="">
        <label for="username">Username</label>
        <input type="text" name="username" id="username" required value="<?= htmlspecialchars($_POST['username'] ?? '') ?>">

        <label for="password">Password</label>
        <input type="password" name="password" id="password" required>

        <label for="confirm_password">Confirm Password</label>
        <input type="password" name="confirm_password" id="confirm_password" required>

        <button type="submit">Register</button>
    </form>
    <p>Already have an account? <a href="login.php">Login here</a>.</p>
</div>
</body>
</html>