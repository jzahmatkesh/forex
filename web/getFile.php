<?php
    header("Content-Type: text/html;charset=UTF-8");
    header('Access-Control-Allow-Origin: *');

    $servername = "localhost";
    $username = "topchart_zahmatkesh";
    $password = "S2f2IsMineB@be";
    $db = "topchart_DBzahmatk";
    $kind = $_GET['type'];

    // Create connection
    $conn = new mysqli($servername, $username, $password, $db);
    $conn->set_charset("utf8");
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    if(isset($_POST['image'])){   
        $id = $_GET['id'];
        $base64_string = $_POST["image"];

        $outputfile = "";
        if ($kind == "Analyze_Small")
            $outputfile = "upload/Analyze_Small$id.jpg";
        else if ($kind == "AnalyzeBig")
            $outputfile = "upload/Analyze_Big$id.jpg" ;
        else
            $outputfile = "upload/$kind$id.jpg";
        //save as image.jpg in uploads/ folder
    
        $filehandler = fopen($outputfile, 'wb' ); 
        //file open with "w" mode treat as text file
        //file open with "wb" mode treat as binary file
        
        fwrite($filehandler, base64_decode($base64_string));
        // we could add validation here with ensuring count($data)>1
    
        // clean up the file resource
        fclose($filehandler); 
        
        $rows[] = array("msg" => "Success");
        header('Content-type: application/json');
        http_response_code(202);
        echo json_encode($rows, JSON_UNESCAPED_UNICODE);
}
?>