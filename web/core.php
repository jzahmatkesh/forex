<?php
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

    $command = $_GET['command'];

    if ($command == "Authenticate"){
        $email = $conn->real_escape_string($_GET['email']);
        $pass = $conn->real_escape_string($_GET['pass']);
        $sql = "Call PrcAuthenticate('$email', '$pass');";
        $result = $conn->query($sql);

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
                    $rows[] = array("msg" => $row["msg"]);
                }
                header('Content-type: application/json');
                if ($row["msg"] == "Success")
                    http_response_code(200);
                else
                    http_response_code(404);
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
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
                    $rows[] = array("msg" => $row["msg"]);
                }
                header('Content-type: application/json');
                if ($row["msg"] == "Success")
                    http_response_code(200);
                else
                    http_response_code(404);
                echo json_encode($rows, JSON_UNESCAPED_UNICODE);
            }
        } else {
            $rows[] = array("msg" => 'wrong email or password');
            header('Content-type: application/json');
            http_response_code(404);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        }
    }
    else if ($command == "Signal"){
        $token = $conn->real_escape_string($_GET['token']);
        $sql = "Call PrcSignal('$token');";
        $result = $conn->query($sql);

        $rows = array();
        if (mysqli_num_rows($result) > 0) {
            // output data of each row
            while($row = mysqli_fetch_assoc($result)){
                $rows[] = array(
                    "accountnumber" => (int)$row["AccountNumber"], 
                    "accountname" => $row["AccountName"], 
                    "operationtype" => $row["OperationType"], 
                    "ticket" => (int)$row["Ticket"], 
                    "opentime" => $row["OpenTime"],
                    "type" => $row["Type"],
                    "size" => (double)$row["Size"],
                    "symbol" => $row["Symbol"],
                    "price" => (double)$row["Price"],
                    "stoploss" => (double)$row["StopLoss"],
                    "takeprofit" => (double)$row["TakeProfit"],
                    "closeprice" => (double)$row["ClosePrice"],
                    "closetime" => $row["CloseTime"],
                    "sender" => $row["Sender"],
                    "profit" => (double)$row["Profit"],
                    "premium" => (int)$row["premium"],
                    "liked" => (int)$row["liked"],
                    "likes" => (int)$row["likes"]
                );
            }
            header('Content-type: application/json');
            http_response_code(200);
            echo json_encode($rows, JSON_UNESCAPED_UNICODE);
        } else {
            $rows[] = array("msg" => 'wrong email or password');
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
