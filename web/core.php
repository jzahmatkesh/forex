<?php
    use PHPMailer\PHPMailer\PHPMailer;
    use PHPMailer\PHPMailer\Exception;

    require 'PHPMailer/Exception.php';
    require 'PHPMailer/PHPMailer.php';
    require 'PHPMailer/SMTP.php';
    header("Content-Type: text/html;charset=UTF-8");
    header('Access-Control-Allow-Origin: *');

    $servername = "localhost";
    $username = "topchart_zahmatkesh";
    $password = "S2f2IsMineB@be";
    $db = "topchart_DBzahmatk";

    // Create connection
    $conn = new mysqli($servername, $username, $password, $db);
    $conn->set_charset("utf8");
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    function sendMail($sendto, $note){
        // try{
            $mail = new PHPMailer(true);

            $mail->isSMTP();// Set mailer to use SMTP
            $mail->CharSet = "utf-8";// set charset to utf8
            $mail->SMTPAuth = true;// Enable SMTP authentication
            $mail->SMTPSecure = 'tls';// Enable TLS encryption, `ssl` also accepted
            
            $mail->Host = 'mail.topchart.org';// Specify main and backup SMTP servers
            $mail->Port = 587;// TCP port to connect to
            $mail->SMTPOptions = array(
                'ssl' => array(
                    'verify_peer' => false,
                    'verify_peer_name' => false,
                    'allow_self_signed' => true
                )
            );
            $mail->isHTML(true);// Set email format to HTML
            
            $mail->Username = 'info@topchart.org';// SMTP username
            $mail->Password = 'P@$$w0rd';// SMTP password
            
            $mail->setFrom('info@topchart.org', 'Topchart Co');//Your application NAME and EMAIL
            $mail->Subject = "Email confirmation code";//Message subject
            $mail->MsgHTML("$note");// Message body
            $mail->addAddress("$sendto", 'User Unknown');// Target email
            
            
            $mail->send();
        // }
        // catch(Exception $e){
        //     $rows[] = array("msg" => "error sending confirmation mail $e");
        //     header('Content-type: application/json');
        //     echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        // }
    }

    $command = $_GET['command'];

    if ($command == "Authenticate"){
        $email = $conn->real_escape_string($_GET['email']);
        $pass = $conn->real_escape_string($_GET['pass']);
        $sql = "Call PrcAuthenticate('$email', '$pass');";
        $result = $conn->query($sql);
        $msg = ""; 
        $rows = array();
        if (mysqli_num_rows($result) > 0) {
            // output data of each row
            while($row = mysqli_fetch_assoc($result)){
                if ($row["msg"] == "Success"){
                    $rows[] = array(
                        "msg" => 'Success', 
                        "id" => (int)$row["id"], 
                        "family" => $row["family"], 
                        "mobile" => $row["mobile"], 
                        "email" => $row["email"], 
                        "accountnumber" => (int)$row["accountnumber"], 
                        "usrmng" => (int)$row["UsrMng"], 
                        "analysis" => (int)$row["Analysis"], 
                        "subscription" => (int)$row["Subscription"], 
                        "regdate" => $row["RegisterDate"], 
                        "ticketmng" => $row["ticketmng"], 
                        "instagram" => $row["instagram"], 
                        "telegram" => $row["telegram"], 
                        "whatsapp" => $row["whatsapp"], 
                        "follower" => (int)$row["follower"], 
                        "ticket" => (int)$row["ticket"],
                        "token" => $row["token"]
                    );
                }
                else{
                    $msg = array("msg" => $row["msg"]);
                }
            }
            header('Content-type: application/json');
            if ($msg == "")
                http_response_code(200);
            else{
                $rows[] = $msg;
                http_response_code(404);
            }
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        } else {
            $rows[] = array("msg" => 'wrong email or password');
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "Verify"){
        $token = $conn->real_escape_string($_GET['token']);
        $sql = "Call PrcAuthenticateByVerify('$token');";
        $result = $conn->query($sql);
        $msg = ""; 
        $rows = array();
        if (mysqli_num_rows($result) > 0) {
            // output data of each row
            while($row = mysqli_fetch_assoc($result)){
                if ($row["msg"] == "Success"){
                    $rows[] = array(
                        "msg" => 'Success', 
                        "id" => (int)$row["id"], 
                        "family" => $row["family"], 
                        "mobile" => $row["mobile"], 
                        "email" => $row["email"], 
                        "accountnumber" => (int)$row["accountnumber"], 
                        "usrmng" => (int)$row["UsrMng"], 
                        "analysis" => (int)$row["Analysis"], 
                        "subscription" => (int)$row["Subscription"], 
                        "regdate" => $row["RegisterDate"], 
                        "ticketmng" => $row["ticketmng"], 
                        "instagram" => $row["instagram"], 
                        "telegram" => $row["telegram"], 
                        "whatsapp" => $row["whatsapp"], 
                        "follower" => (int)$row["follower"], 
                        "ticket" => (int)$row["ticket"],
                        "token" => $row["token"]
                    );
                }
                else{
                    $msg = array("msg" => $row["msg"]);
                }
            }
            header('Content-type: application/json');
            if ($msg == "")
                http_response_code(200);
            else{
                $rows[] = $msg;
                http_response_code(404);
            }
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        } else {
            $rows[] = array("msg" => 'wrong email or password');
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "Signal"){
        $token = $conn->real_escape_string($_GET['token']);
        $sort = $conn->real_escape_string($_GET['sort']);
        $sql = "Call PrcSignal('$token', $sort);";
        $result = $conn->query($sql);

        $rows = array();
        if (mysqli_num_rows($result) > 0) {
            // output data of each row
            while($row = mysqli_fetch_assoc($result)){
                $rows[] = array(
                    "accountnumber" => (int)$row["AccountNumber"], 
                    "accountname" => $row["AccountName"], 
                    "userid" => (int)$row["userid"], 
                    "operationtype" => (int)$row["OperationType"], 
                    "ticket" => (int)$row["Ticket"], 
                    "opentime" => $row["OpenTime"],
                    "type" => (int)$row["Type"],
                    "size" => (double)$row["Size"],
                    "symbol" => $row["Symbol"],
                    "price" => (double)$row["Price"],
                    "stoploss" => (double)$row["StopLoss"],
                    "takeprofit" => (double)$row["TakeProfit"],
                    "closeprice" => (double)$row["ClosePrice"],
                    "closetime" => $row["CloseTime"],
                    "sender" => $row["Sender"],
                    "profit" => (double)$row["Profit"],
                    "ProfitPoint" => (double)$row["ProfitPoint"],
                    "premium" => (int)$row["premium"],
                    "liked" => (int)$row["liked"],
                    "likes" => (int)$row["likes"]
                );
            }
            header('Content-type: application/json');
            http_response_code(200);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        } else {
            $rows[] = array("msg" => 'error in connection to database');
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "SignalLike"){
        $token = $conn->real_escape_string($_GET['token']);
        $ticket = $conn->real_escape_string($_GET['ticket']);
        $sql = "Call PrcSignalLike('$token', $ticket);";
        $result = $conn->query($sql);

        $rows = array();
        $msg = "";
        if (mysqli_num_rows($result) > 0) {
            // output data of each row
            while($row = mysqli_fetch_assoc($result)){
                $msg = $row["msg"];
                $rows[] = array("msg" => $row["msg"]);
            }
            header('Content-type: application/json');
            if ($msg == "Success")
                http_response_code(200);
            else
                http_response_code(500);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        } else {
            $rows[] = array("msg" => 'error in connection to database');
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "SignalComment"){
        $token = $conn->real_escape_string($_GET['token']);
        $ticket = $conn->real_escape_string($_GET['ticket']);
        $sql = "Call PrcSignalComment('$token', $ticket);";
        $result = $conn->query($sql);

        $rows = array();
        if (mysqli_num_rows($result) > 0) {
            // output data of each row
            while($row = mysqli_fetch_assoc($result)){
                $rows[] = array(
                    "id" => (int)$row["ID"], 
                    "date" => $row["date"], 
                    "note" => $row["note"], 
                    "userid" => (int)$row["userid"], 
                    "userfamily" => $row["UserFamily"], 
                );
            }
            header('Content-type: application/json');
            http_response_code(200);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        } else {
            header('Content-type: application/json');
            http_response_code(200);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "AddSignalComment"){
        $token = $conn->real_escape_string($_GET['token']);
        $ticket = $conn->real_escape_string($_GET['ticket']);
        $note = $conn->real_escape_string($_GET['note']);
        $sql = "Call PrcAddSignalComment('$token', $ticket, '$note');";
        $result = $conn->query($sql);

        $rows = array();
        $msg = "";
        if (mysqli_num_rows($result) > 0) {
            // output data of each row
            while($row = mysqli_fetch_assoc($result)){
                $msg = $row["msg"];
                $rows[] = array("msg" => $row["msg"], "id" => (int)$row["id"]);
            }
            header('Content-type: application/json');
            if ($msg == "Success")
                http_response_code(200);
            else
                http_response_code(500);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        } else {
            $rows[] = array("msg" => 'error in connection to database');
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "Analyze"){
        $token = $conn->real_escape_string($_GET['token']);
        $sql = "Call PrcAnalyze('$token');";
        $result = $conn->query($sql);

        $rows = array();
        if (mysqli_num_rows($result) > 0) {
            // output data of each row
            while($row = mysqli_fetch_assoc($result)){
                $rows[] = array(
                    // A.ID, A.symbol, A.title, A.note, A.date, B.family sender, A.premium, A.Kind, A.`status`
                    "id" => (int)$row["ID"], 
                    "symbol" => $row["symbol"], 
                    "subject" => $row["title"], 
                    "note" => $row["note"], 
                    "senddate" => $row["date"],
                    "senderid" => (int)$row["senderid"],
                    "sender" => $row["sender"],
                    "premium" => (int)$row["premium"],
                    "kind" => (int)$row["kind"],
                    "status" => (int)$row["status"],
                    "liked" => (int)$row["liked"],
                    "likes" => (int)$row["likes"],
                    "expiredate" => $row["expiredate"]
                );
            }
            header('Content-type: application/json');
            http_response_code(200);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        } else {
            $rows[] = array("msg" => 'error in connection to database');
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "AnalyzeLike"){
        $token = $conn->real_escape_string($_GET['token']);
        $id = $conn->real_escape_string($_GET['id']);
        $sql = "Call PrcAnalyzeLike('$token', $id);";
        $result = $conn->query($sql);

        $rows = array();
        $msg = "";
        if (mysqli_num_rows($result) > 0) {
            // output data of each row
            while($row = mysqli_fetch_assoc($result)){
                $msg = $row["msg"];
                $rows[] = array("msg" => $row["msg"]);
            }
            header('Content-type: application/json');
            if ($msg == "Success")
                http_response_code(200);
            else
                http_response_code(500);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        } else {
            $rows[] = array("msg" => 'error in connection to database');
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "AnalyzeComment"){
        $token = $conn->real_escape_string($_GET['token']);
        $id= $conn->real_escape_string($_GET['id']);
        $sql = "Call PrcAnalyzeComment('$token', $id);";
        $result = $conn->query($sql);

        $rows = array();
        if (mysqli_num_rows($result) > 0) {
            // output data of each row
            while($row = mysqli_fetch_assoc($result)){
                $rows[] = array(
                    "id" => (int)$row["ID"], 
                    "date" => $row["date"], 
                    "note" => $row["note"], 
                    "userid" => (int)$row["userid"], 
                    "userfamily" => $row["UserFamily"], 
                );
            }
            header('Content-type: application/json');
            http_response_code(200);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        } else {
            header('Content-type: application/json');
            http_response_code(200);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "AddAnalyzeComment"){
        $token = $conn->real_escape_string($_GET['token']);
        $id = $conn->real_escape_string($_GET['id']);
        $note = $conn->real_escape_string($_GET['note']);
        $sql = "Call PrcAddAnalyzeComment('$token', $id, '$note');";
        $result = $conn->query($sql);

        $rows = array();
        $msg = "";
        if (mysqli_num_rows($result) > 0) {
            // output data of each row
            while($row = mysqli_fetch_assoc($result)){
                $msg = $row["msg"];
                $rows[] = array("msg" => $row["msg"], "id" => (int)$row["id"]);
            }
            header('Content-type: application/json');
            if ($msg == "Success")
                http_response_code(200);
            else
                http_response_code(500);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        } else {
            $rows[] = array("msg" => 'error in connection to database');
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "Subscribe"){
        $token = $conn->real_escape_string($_GET['token']);
        $sql = "Call PrcSubscribe('$token');";
        $result = $conn->query($sql);
        $msg = "";
        $rows = array();
        if (mysqli_num_rows($result) > 0) {
            // output data of each row
            while($row = mysqli_fetch_assoc($result)){
                if ($row["msg"] == "Success")
                    $rows[] = array(
                        "id" => (int)$row["id"], 
                        "active" => (int)$row["active"], 
                        "title" => $row["title"], 
                        "note" => $row["note"], 
                        "price" => (int)$row["price"],
                        "price2" => (int)$row["price2"],
                    );
                else
                    $msg = array("msg" => $row["msg"]);
            }
            header('Content-type: application/json');
            if ($msg == "")
                http_response_code(200);
            else{
                $rows[] = $msg;
                http_response_code(404);
            }
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        } else {
            $rows[] = array("msg" => 'error in connection to database');
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "symbol"){
        $token = $conn->real_escape_string($_GET['token']);
        $sql = "Select Distinct symbol From TBSignal";
        $result = $conn->query($sql);
        $msg = "";
        $rows = array();
        if (mysqli_num_rows($result) > 0) {
            while($row = mysqli_fetch_assoc($result)){
                $rows[] = array("symbol" => $row["symbol"]);
            }
            header('Content-type: application/json');
            http_response_code(200);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        } else {
            $rows[] = array("msg" => 'error in connection to database');
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "SaveSubscribe"){
        $token = $conn->real_escape_string($_GET['token']);
        $id = $conn->real_escape_string($_GET['id']);
        $title = $conn->real_escape_string($_GET['title']);
        $price1 = $conn->real_escape_string($_GET['price1']);
        $price2 = $conn->real_escape_string($_GET['price2']);
        $note = $conn->real_escape_string($_GET['note']);
        $sql = "Call PrcSaveSubscribe('$token', $id, '$title', $price1, $price2, '$note');";
        $result = $conn->query($sql);
        $msg = "";
        $rows = array();
        if (mysqli_num_rows($result) > 0) {
            while($row = mysqli_fetch_assoc($result)){
                header('Content-type: application/json');
                $rows[] = array("msg" => $row["msg"]);
                if ($row["msg"] == "Success")
                    http_response_code(200);
                else
                    http_response_code(404);
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        } else {
            $rows[] = array("msg" => 'error in connection to database');
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "ActiveSubscribe"){
        $token = $conn->real_escape_string($_GET['token']);
        $id = $conn->real_escape_string($_GET['id']);
        $active = $conn->real_escape_string($_GET['active']);
        $sql = "Call PrcActiveSubscribe('$token', $id, $active);";
        $result = $conn->query($sql);
        $msg = "";
        $rows = array();
        if (mysqli_num_rows($result) > 0) {
            while($row = mysqli_fetch_assoc($result)){
                header('Content-type: application/json');
                $rows[] = array("msg" => $row["msg"]);
                if ($row["msg"] == "Success")
                    http_response_code(200);
                else
                    http_response_code(404);
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        } else {
            $rows[] = array("msg" => 'error in connection to database');
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "SaveSignal"){
        try{
            $token = $conn->real_escape_string($_GET['token']);
            // $accountname = $conn->real_escape_string($_GET['accountname']);
            $premium = $conn->real_escape_string($_GET['premium']);
            $accountnumber = $conn->real_escape_string($_GET['accountnumber']);
            $operationtype = $conn->real_escape_string($_GET['operationtype']);
            $ticket = $conn->real_escape_string($_GET['ticket']);
            $opentime = $conn->real_escape_string($_GET['opentime']);
            $type = $conn->real_escape_string($_GET['type']);
            $size = $conn->real_escape_string($_GET['size']);
            $symbol = $conn->real_escape_string($_GET['symbol']);
            $price = $conn->real_escape_string($_GET['price']);
            $stoploss = $conn->real_escape_string($_GET['stoploss']);
            $takeprofit = $conn->real_escape_string($_GET['takeprofit']);
            $closeprice = $conn->real_escape_string($_GET['closeprice']);
            $closetime = $conn->real_escape_string($_GET['closetime']);
            $profit = $conn->real_escape_string($_GET['profit']);

            $sql = "Call PrcSaveSignal('$token', $premium,$accountnumber,'$operationtype',$ticket,'$opentime','$type',$size,'$symbol',$price,$stoploss,$takeprofit,$closeprice,'$closetime',$profit);";

            $result = $conn->query($sql);
            $msg = "";
            $rows = array();
            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)){
                    header('Content-type: application/json');
                    $rows[] = array("msg" => $row["msg"]);
                    if ($row["msg"] == "Success")
                        http_response_code(200);
                    else
                        http_response_code(404);
                    echo json_encode($rows, JSON_UNESCAPED_UNICODE);
                }
            } else {
                $rows[] = array("msg" => "error in send data to database");
                header('Content-type: application/json');
                http_response_code(404);
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "DelSignal"){
        try{
            $token = $conn->real_escape_string($_GET['token']);
            $ticket = $conn->real_escape_string($_GET['ticket']);

            $sql = "Call PrcDelSignal('$token', $ticket);";

            $result = $conn->query($sql);
            $msg = "";
            $rows = array();
            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)){
                    header('Content-type: application/json');
                    $rows[] = array("msg" => $row["msg"]);
                    if ($row["msg"] == "Success")
                        http_response_code(200);
                    else
                        http_response_code(404);
                    echo json_encode($rows, JSON_UNESCAPED_UNICODE);
                }
            } else {
                $rows[] = array("msg" => "error in send data to database");
                header('Content-type: application/json');
                http_response_code(404);
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "SaveAnalyze"){
        try{
            $token = $conn->real_escape_string($_GET['token']);
            $id = $conn->real_escape_string($_GET['id']);
            $title = $conn->real_escape_string($_GET['title']);
            $symbol = $conn->real_escape_string($_GET['symbol']);
            $kind = $conn->real_escape_string($_GET['kind']);
            $status = $conn->real_escape_string($_GET['status']);
            $premium = $conn->real_escape_string($_GET['premium']);
            $expire = $conn->real_escape_string($_GET['expire']);
            $note = $conn->real_escape_string($_GET['note']);

            $sql = "Call PrcSaveAnalyze('$token', $id, '$title', '$symbol', $kind, $status, $premium, '$expire', '$note');";

            $result = $conn->query($sql);
            $msg = "";
            $rows = array();
            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)){
                    header('Content-type: application/json');
                    $rows[] = array("msg" => $row["msg"], "id" => (int)$row["id"]);
                    if ($row["msg"] == "Success")
                        http_response_code(200);
                    else
                        http_response_code(404);
                    echo json_encode($rows, JSON_UNESCAPED_UNICODE);
                }
            } else {
                $rows[] = array("msg" => "error in send data to database");
                header('Content-type: application/json');
                http_response_code(404);
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "DelAnalyze"){
        try{
            $token = $conn->real_escape_string($_GET['token']);
            $id = $conn->real_escape_string($_GET['id']);

            $sql = "Call PrcDelAnalyze('$token', $id);";

            $result = $conn->query($sql);
            $msg = "";
            $rows = array();
            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)){
                    header('Content-type: application/json');
                    $rows[] = array("msg" => $row["msg"]);
                    if ($row["msg"] == "Success")
                        http_response_code(200);
                    else
                        http_response_code(404);
                    echo json_encode($rows, JSON_UNESCAPED_UNICODE);
                }
            } else {
                $rows[] = array("msg" => "error in send data to database");
                header('Content-type: application/json');
                http_response_code(404);
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "Users"){
        $token = $conn->real_escape_string($_GET['token']);
        $sql = "Call PrcUsers('$token');";
        $result = $conn->query($sql);

        $rows = array();
        if (mysqli_num_rows($result) > 0) {
            while($row = mysqli_fetch_assoc($result)){
                if ($row["msg"] == "Success"){
                    http_response_code(200);
                    $rows[] = array(
                        "id" => (int)$row["id"], 
                        "family" => $row["family"], 
                        "mobile" => $row["mobile"], 
                        "email" => $row["email"], 
                        "accountnumber" => (int)$row["accountnumber"], 
                        "paccountnumber" => (int)$row["paccountnumber"], 
                        "lastlogin" => $row["lastlogin"],
                        "usrmng" => (int)$row["usrmng"],
                        "analysis" => (int)$row["analysis"],
                        "subscription" => (int)$row["subscription"],
                        "registerdate" => $row["registerdate"],
                        "ticketmng" => (int)$row["ticketmng"],
                        "instagram" => $row["instagram"],
                        "telegram" => $row["telegram"],
                        "whatsapp" => $row["whatsapp"],
                        "active" => (int)$row["active"],
                        "analysiscount" => (int)$row["analysiscount"],
                        "signalcount" => (int)$row["signalcount"],
                        "likes" => (int)$row["likes"],
                        "follower" => (int)$row["follower"]
                    );
                }
                else{
                    http_response_code(404);
                    $rows[] = array("msg" => $row["msg"]);
                }
            }
            header('Content-type: application/json');
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        } else {
            $rows[] = array("msg" => 'error in connection to database');
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "SaveUser"){
        try{
            $token = $conn->real_escape_string($_GET['token']);
            $id = $conn->real_escape_string($_GET['id']);
            $family = $conn->real_escape_string($_GET['family']);
            $mobile = $conn->real_escape_string($_GET['mobile']);
            $email = $conn->real_escape_string($_GET['email']);
            $telegram = $conn->real_escape_string($_GET['telegram']);
            $instagram = $conn->real_escape_string($_GET['instagram']);
            $whatsapp = $conn->real_escape_string($_GET['whatsapp']);
            $accountnumber = $conn->real_escape_string($_GET['accountnumber']);
            $paccountnumber = $conn->real_escape_string($_GET['paccountnumber']);
            $usermng = $conn->real_escape_string($_GET['usermng']);
            $analysis = $conn->real_escape_string($_GET['analysis']);
            $subscription = $conn->real_escape_string($_GET['subscription']);
            $ticketmng = $conn->real_escape_string($_GET['ticketmng']);
            $usrpass = $conn->real_escape_string($_GET['usrpass']);

            $sql = "Call PrcSaveUser('$token', $id, '$family', '$mobile', '$email', '$telegram', '$instagram', '$whatsapp', $accountnumber, $paccountnumber, $usermng, $analysis, $subscription, $ticketmng, '$usrpass');";

            $result = $conn->query($sql);
            $msg = "";
            $rows = array();
            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)){
                    header('Content-type: application/json');
                    $rows[] = array("msg" => $row["msg"], "id" => (int)$row["id"]);
                    if ($row["msg"] == "Success")
                        http_response_code(200);
                    else
                        http_response_code(404);
                    echo json_encode($rows, JSON_UNESCAPED_UNICODE);
                }
            } else {
                $rows[] = array("msg" => "error in send data to database $sql");
                header('Content-type: application/json');
                http_response_code(404);
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "ActiveUser"){
        try{
            $token = $conn->real_escape_string($_GET['token']);
            $id = $conn->real_escape_string($_GET['id']);
            $act = $conn->real_escape_string($_GET['active']);

            $sql = "Call PrcSetUserActive('$token', $id, $act);";

            $result = $conn->query($sql);
            $msg = "";
            $rows = array();
            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)){
                    header('Content-type: application/json');
                    $rows[] = array("msg" => $row["msg"]);
                    if ($row["msg"] == "Success")
                        http_response_code(200);
                    else
                        http_response_code(404);
                    echo json_encode($rows, JSON_UNESCAPED_UNICODE);
                }
            } else {
                $rows[] = array("msg" => "error in send data to database");
                header('Content-type: application/json');
                http_response_code(404);
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "DelUser"){
        try{
            $token = $conn->real_escape_string($_GET['token']);
            $id = $conn->real_escape_string($_GET['id']);

            $sql = "Call PrcDelUser('$token', $id);";

            $result = $conn->query($sql);
            $msg = "";
            $rows = array();
            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)){
                    header('Content-type: application/json');
                    $rows[] = array("msg" => $row["msg"]);
                    if ($row["msg"] == "Success")
                        http_response_code(200);
                    else
                        http_response_code(404);
                    echo json_encode($rows, JSON_UNESCAPED_UNICODE);
                }
            } else {
                $rows[] = array("msg" => "error in send data to database");
                header('Content-type: application/json');
                http_response_code(404);
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "SendMail"){
        try{
            $sendto = $_GET['sendto'];
            $digit = mt_rand(100000, 999999);
            sendMail("$sendto", "Confirmation Code: $digit");
            $rows = array();
            $rows[] = array("msg" => "Success", "digit" => "$digit");
            header('Content-type: application/json');
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "RegisterUser"){
        try{
            $family = $conn->real_escape_string($_GET['family']);
            $mobile = $conn->real_escape_string($_GET['mobile']);
            $email = $conn->real_escape_string($_GET['email']);
            $pass = $conn->real_escape_string($_GET['pass']);
            $sql = "Call PrcRegisterUser('$family', '$mobile', '$email', '$pass');";

            $result = $conn->query($sql);
            $msg = "";
            $rows = array();
            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)){
                    header('Content-type: application/json');
                    if ($row["msg"] == "Success"){
                        http_response_code(200);
                        $rows[] = array(
                            "msg" => 'Success', 
                            "id" => (int)$row["id"], 
                            "family" => $row["family"], 
                            "mobile" => $row["mobile"], 
                            "email" => $row["email"], 
                            "accountnumber" => (int)$row["accountnumber"], 
                            "usrmng" => (int)$row["UsrMng"], 
                            "analysis" => (int)$row["Analysis"], 
                            "subscription" => (int)$row["Subscription"], 
                            "regdate" => $row["RegisterDate"], 
                            "ticketmng" => $row["ticketmng"], 
                            "instagram" => $row["instagram"], 
                            "telegram" => $row["telegram"], 
                            "whatsapp" => $row["whatsapp"], 
                            "follower" => (int)$row["follower"], 
                            "ticket" => (int)$row["ticket"],
                            "token" => $row["token"]
                        );
                    }
                    else{
                        http_response_code(404);
                        $rows[] = array("msg" => $row["msg"]);
                    }
                    echo json_encode($rows, JSON_UNESCAPED_UNICODE);
                }
            } else {
                $rows[] = array("msg" => "error in send data to database");
                header('Content-type: application/json');
                http_response_code(404);
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }









    else if ($command == "LoadUsers"){
        $rows = array();
        try{
            $id = $_GET['userid'];
            $sql = "Call LoadUsers($id);";
            $result = $conn->query($sql);

            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)) {
                    if ($row["msg"] == "Success")
                        $rows[] = array("msg" => $row["msg"], "id" => (int)$row["id"], "family" => $row["family"], "mobile" => $row["mobile"], "email" => $row["email"], "lastlogin" => $row["lastlogin"], "accountnumber" => $row["accountnumber"], "usrmng" => (int)$row["UsrMng"], "analysis" => (int)$row["Analysis"], "subscription" => (int)$row["Subscription"]);
                    else
                        $rows[] = array("msg" => $row["msg"]);
                }
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
            else{
                $rows[] = array("msg" => "server error");
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command  == "SaveUser"){
        $userid = $_GET['userid'];
        $id = $_GET['id'];
        $family = $_GET['family'];
        $email = $_GET['email'];
        $mobile = $_GET['mobile'];
        $accountnumber = $_GET['accountnumber'];
        $password = $_GET['password'];
        $usrmng = $_GET['usrmng'];
        $analysis = $_GET['analysis'];

        $sql = "Call SaveUser($userid, $id, '$family', '$email', '$mobile', $accountnumber, '$password', $usrmng, $analysis);";
        $result = $conn->query($sql);
        if (mysqli_num_rows($result) > 0) {
            $rows = array();
            while($row = mysqli_fetch_assoc($result)) {
                $rows[] = array("msg" => $row["msg"]);
            }
            header('Content-type: application/json');
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
        else {
            $rows[] = array("msg" => 'not return anything');
            header('Content-type: application/json');
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "SetUserPermission"){
        $userid = $_GET['userid'];
        $id = $_GET['id'];
        $prm = $_GET['prm'];
        
        $sql = "Call SetUserPermission($userid, $id, '$prm');";
        $result = $conn->query($sql);
        if (mysqli_num_rows($result) > 0) {
            $rows = array();
            while($row = mysqli_fetch_assoc($result)) {
                $rows[] = array("msg" => $row["msg"]);
            }
            header('Content-type: application/json');
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
        else {
            $rows[] = array("msg" => 'not return anything');
            header('Content-type: application/json');
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "LoadAnalyze"){
        $rows = array();
        try{
            $id = $_GET['userid'];
            $sql = "Call LoadAnalyze($id);";
            $result = $conn->query($sql);

            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)) {
                    if ($row["msg"] == "Success")
                        $rows[] = array("msg" => $row["msg"], "id" => $row["id"], "title" => $row["title"], "symbol" => $row["symbol"], "date" => $row["date"], "trader" => $row["trader"], "note" => $row["note"], "userid" => $row["userid"], "likes" => $row["likes"], "comments" => $row["comments"], "followers" => $row["followers"], "premium" => $row["premium"]);
                    else
                        $rows[] = array("msg" => $row["msg"]);
                }
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
            else{
                $rows[] = array("msg" => "server error");
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "SaveAnalyze"){
        $rows = array();
        try{
            $userid  = $_GET['userid'];
            $id      = $_GET['id'];
            $title   = $_GET['title'];
            $symbol  = $_GET['symbol'];
            $note    = $_GET['note'];
            $premium = $_GET['premium'];
            $sql = "Call SaveAnalyze($userid, $id, '$title', '$symbol', '$note', $premium);";
            $result = $conn->query($sql);

            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)) 
                    $rows[] = array("msg" => $row["msg"]);
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
            else{
                $rows[] = array("msg" => "server error");
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "SetAnalyzePremium"){
        $rows = array();
        try{
            $userid  = $_GET['userid'];
            $id      = $_GET['id'];
            $sql = "Call SetAnalyzePremium($userid, $id);";
            $result = $conn->query($sql);

            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)) 
                    $rows[] = array("msg" => $row["msg"]);
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
            else{
                $rows[] = array("msg" => "server error");
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "LoadTicket"){
        $rows = array();
        try{
            $id = $_GET['userid'];
            $sql = "Call LoadTickets($id);";
            $result = $conn->query($sql);

            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)) {
                     $rows[] = array("id" => $row["id"], "userid" => $row["userid"], "userfamily" => $row["userfamily"], "title" => $row["title"], "message" => $row["message"], "cdate" => $row["cdate"], "sdate" => $row["sdate"], "seen" => $row["seen"]);
                }
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
            else{
                $rows[] = array("msg" => "server error");
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "LoadTicketInfo"){
        $rows = array();
        try{
            $usrid = $_GET['userid'];
            $tid = $_GET['id'];
            $sql = "Call LoadTicketAnswers($usrid,$tid);";
            $result = $conn->query($sql);

            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)) {
                    $rows[] = array("id" => $row["id"], "userid" => $row["userid"], "userfamily" => $row["userfamily"], "title" => $row["title"], "message" => $row["message"], "cdate" => $row["cdate"], "sdate" => $row["sdate"], "seen" => $row["seen"]);
                }
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
            else{
                $rows[] = array("msg" => "server error");
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command=="AnswerTicket"){
        $rows = array();
        try{
            $usrid = $_GET['userid'];
            $tid = $_GET['tid'];
            $nid = $_GET['nid'];
            $msg = $_GET['msg'];
            $sql = "Call AnswerTickets($usrid,$tid,$nid,'$msg');";
            $result = $conn->query($sql);

            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)) {
                    $rows[] = array("msg" => $row["msg"]);
                }
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
            else{
                $rows[] = array("msg" => "server error");
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command=="SaveTicket"){
        $rows = array();
        try{
            $usrid = $_GET['userid'];
            $tid = $_GET['tid'];
            $ttl = $_GET['ttl'];
            $msg = $_GET['msg'];
            $sql = "Call SaveTickets($usrid,$tid,'$ttl','$msg');";
            $result = $conn->query($sql);

            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)) {
                    $rows[] = array("msg" => $row["msg"]);
                }
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
            else{
                $rows[] = array("msg" => "server error");
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "SaveUserProfile"){
        $rows = array();
        try{
            $id = $_GET['id'];
            $family = $_GET['family'];
            $email = $_GET['email'];
            $instagram = $_GET['instagram'];
            $telegram  = $_GET['telegram'];
            $whatsapp  = $_GET['whatsapp'];
            $sql = "Call SaveUserInfo($id,'$family','$email','$instagram','$telegram','$whatsapp');";
            $result = $conn->query($sql);

            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)) {
                    $rows[] = array("msg" => $row["msg"]);
                }
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
            else{
                $rows[] = array("msg" => "server error");
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "LoadSubscription"){
        $rows = array();
        try{
            $id = $_GET['userid'];
            $sql = "Call LoadSubscription($id);";
            $result = $conn->query($sql);

            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)) {
                     $rows[] = array("id" => (int)$row["ID"], "kind" => (int)$row["Kind"], "title" => $row["Title"], "time" => $row["Time"], "price" => (int)$row["Price"], "price2" => (int)$row["Price2"], "note" => $row["Note"]);
                }
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
            else{
                $rows[] = array("msg" => "server error");
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "SaveSubscription"){
        $rows = array();
        try{
            $user = $_GET['userid'];
            $id = $_GET['id'];
            $title = $_GET['title'];
            $price = $_GET['price'];
            $price2 = $_GET['price2'];
            $kind = $_GET['kind'];
            $time = $_GET['time'];
            $note = $_GET['note'];
            $sql = "Call SaveSubscription($user,$id,'$title',$price,$price2,$kind,'$time','$note');";
            $result = $conn->query($sql);

            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)) {
                     $rows[] = array("msg" => $row["msg"]);
                }
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
            else{
                $rows[] = array("msg" => "server error");
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "delSubscription"){
        $rows = array();
        try{
            $user = $_GET['userid'];
            $id = $_GET['id'];
            $sql = "Call DelSubscription($user,$id);";
            $result = $conn->query($sql);

            if (mysqli_num_rows($result) > 0) {
                while($row = mysqli_fetch_assoc($result)) {
                     $rows[] = array("msg" => $row["msg"]);
                }
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
            else{
                $rows[] = array("msg" => "server error");
                header('Content-type: application/json');
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        }
        catch(Exception $e){
            $rows[] = array("msg" => "error:");
            header('Content-type: application/json');
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    $conn->close();
?>
