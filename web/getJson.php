<?php

    // $json = file_get_contents('php://input');
    // $data = json_decode($json);
    $servername = "localhost";
    $username = "topchart_zahmatkesh";
    $password = "S2f2IsMineB@be";
    $db = "topchart_DBzahmatk";

    $conn = new mysqli($servername, $username, $password, $db);
    $conn->set_charset("utf8");
    // Check connection
    if ($conn->connect_error) {
        $rawData = array("type" => -4, "msg" => "Error connecting to database");
        header('Content-type: application/json');
        echo json_encode($rawData, JSON_UNESCAPED_UNICODE);
        die("Connection failed: " . $conn->connect_error);
    }

    try{
        if(isset($_POST['json'])) {
            $json = json_decode($_POST["json"],JSON_PRETTY_PRINT);

            $accountname = $json["AccountName"];
            $accountnumber = $json["AccountNumber"];
            $operationtype = $json["PositionOperation"][0]["OperationType"];
            $Ticket = $json["PositionOperation"][0]["Ticket"];
            $OpenTime = $json["PositionOperation"][0]["OpenTime"];
            $Type = $json["PositionOperation"][0]["Type"];
            $Size = $json["PositionOperation"][0]["Size"];
            $Symbol = $json["PositionOperation"][0]["Symbol"];
            $Price = $json["PositionOperation"][0]["Price"];
            $Stoploss = $json["PositionOperation"][0]["Stoploss"];
            $Takeprofit = $json["PositionOperation"][0]["Takeprofit"];
            $ClosePrice = $json["PositionOperation"][0]["ClosePrice"];
            $CloseTime = $json["PositionOperation"][0]["CloseTime"];
            $Profit = $json["PositionOperation"][0]["Profit"];

            $sql = "CALL PrcWriteSignal('$accountname', $accountnumber, '$operationtype', $Ticket, '$OpenTime', '$Type', $Size, '$Symbol', $Price, $Stoploss, $Takeprofit, $ClosePrice, '$CloseTime', $Profit);";

            $sqlfile = fopen("sql.txt", "w") or die("Unable to open file!");
            $stxt = "sql:  " .$sql;
            fwrite($sqlfile, $stxt);
            fclose($sqlfile);

            $result = $conn->query($sql);
    
            $rows = array();
            if (mysqli_num_rows($result) > 0) {
                // output data of each row
                while($row = mysqli_fetch_assoc($result)) {
                    $rawData = array("type" => 0, "msg" => $row['msg']);
                    header('Content-type: application/json');
                    echo json_encode($rawData, JSON_UNESCAPED_UNICODE);
                }
            }                            
            else{
                $rawData = array("type" => -1, "msg" => $row['msg']);
                header('Content-type: application/json');
                echo json_encode($rawData, JSON_UNESCAPED_UNICODE);
            }

            $fp = fopen('results'.date("hisa").'.json', 'w');
            fwrite($fp, $json);
            fclose($fp);
        } else {
            $rawData = array("type" => -2, "msg" => "Object Not Received");
            header('Content-type: application/json');
            echo json_encode($rawData, JSON_UNESCAPED_UNICODE);
        }
    }
    catch(Exception $e) {
        $rawData = array("type" => -3, "msg" => "Exception occurred");
        header('Content-type: application/json');
        echo json_encode($rawData, JSON_UNESCAPED_UNICODE);

        $myfile = fopen("error.txt", "w") or die("Unable to open file!");
        $txt = "error:  " .$e->getMessage();
        fwrite($myfile, $txt);
        fclose($myfile);
    }
    $conn->close();
?>