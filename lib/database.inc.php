<?php
function db_connect($db_host, $db_user, $db_pass, $db_name)
{
       global $dbc;
       $dbc = mysqli_connect($db_host, $db_user, $db_pass, $db_name) or die("Kết nối không thành công " . mysqli_connect_error());;
}
function db_query($query_string)
{
       global $dbc;
       $result = mysqli_query($dbc, $query_string);
       mysqli_next_result($dbc);
       if (!$result) {
              // db_sql_error('Query Error', $query_string);
              trigger_error('A system error has occurred. We apologize for any inconvenience.');
       }
       return $result;
}
function db_insert($table, array $data)
{
       global $dbc;
       foreach ($data as $k => $v) {
              $list_field[] = "`$k`";
              $list_value[] = "'$v'";
       }
       $list_field = implode(',', $list_field);
       $list_value = implode(',', $list_value);
       $sql = "INSERT INTO {$table} ({$list_field}) VALUES ({$list_value})";
       db_query($sql);
       // return mysqli_affected_rows($dbc);
       return mysqli_insert_id($dbc);
}
function db_update($table, $data, $where = "")
{
       global $dbc;
       foreach ($data as $k => $v) {
              $data_insert[] = "`{$k}` = '{$v}'";
       }
       $data_insert = implode(",", $data_insert);
       $where = !empty($where) ? "WHERE {$where}" : "";
       db_query("UPDATE {$table} SET {$data_insert} {$where}");
       return mysqli_affected_rows($dbc);
}      
function db_fetch_row($query)
{
       global $dbc;
       $result = array();
       $mysqli_result = db_query($query);
       // $result = mysqli_fetch_array($mysqli_result, MYSQLI_NUM);
       $result = mysqli_fetch_array($mysqli_result, MYSQLI_BOTH);
       // $result = mysqli_fetch_assoc($mysqli_result);
       // mysqli_free_result($mysqli_result);
       // mysqli_next_result($dbc);
       return $result;
}
function db_fetch_array($query)
{
       global $dbc;
       $result = array();
       $mysqli_result = db_query($query);
       // mysqli_free_result($mysqli_result);
       // mysqli_next_result($dbc);
       while ($row = mysqli_fetch_assoc($mysqli_result)) {
              $result[] = $row;
       }
       return $result;
}
function db_num_rows($query)
{
       global $dbc;
       return mysqli_num_rows(db_query($query));
}


function db_delete($table, $where)
{
       global $dbc;
       db_query("DELETE FROM $table WHERE $where");
       return mysqli_affected_rows($dbc);
}
function db_sql_error($message, $query_string = "")
{
       global $dbc;

       $sqlerror = "<table width='100%' border='1' cellpadding='0' cellspacing='0'>";
       $sqlerror .= "<tr><th colspan='2'>{$message}</th></tr>";
       $sqlerror .= ($query_string != "") ? "<tr><td nowrap> Query SQL</td><td nowrap>: " . $query_string . "</td></tr>\n" : "";
       $sqlerror .= "<tr><td nowrap> Error Number</td><td nowrap>: " . mysqli_errno($dbc) . " " . mysqli_error($dbc) . "</td></tr>\n";
       $sqlerror .= "<tr><td nowrap> Date</td><td nowrap>: " . date("D, F j, Y H:i:s") . "</td></tr>\n";
       $sqlerror .= "<tr><td nowrap> IP</td><td>: " . getenv("REMOTE_ADDR") . "</td></tr>\n";
       $sqlerror .= "<tr><td nowrap> Browser</td><td nowrap>: " . getenv("HTTP_USER_AGENT") . "</td></tr>\n";
       $sqlerror .= "<tr><td nowrap> Script</td><td nowrap>: " . getenv("REQUEST_URI") . "</td></tr>\n";
       $sqlerror .= "<tr><td nowrap> Referer</td><td nowrap>: " . getenv("HTTP_REFERER") . "</td></tr>\n";
       $sqlerror .= "<tr><td nowrap> PHP Version </td><td>: " . PHP_VERSION . "</td></tr>\n";
       $sqlerror .= "<tr><td nowrap> OS</td><td>: " . PHP_OS . "</td></tr>\n";
       $sqlerror .= "<tr><td nowrap> Server</td><td>: " . getenv("SERVER_SOFTWARE") . "</td></tr>\n";
       $sqlerror .= "<tr><td nowrap> Server Name</td><td>: " . getenv("SERVER_NAME") . "</td></tr>\n";
       $sqlerror .= "</table>";
       $msgbox_messages = "<meta http-equiv=\"refresh\" content=\"9999\">\n<table class='smallgrey' cellspacing=1 cellpadding=0>" . $sqlerror . "</table>";
       echo $msgbox_messages;
       exit;
}
