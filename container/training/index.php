<?php

echo "hello world \n";
echo "hello gourav sengupta\n\n";


header("content-type: html");
$host= "db"; //The hostname "db" from our docker-compose.yml file!!!
$username= "root"; //We use the root user
$pw= "root"; //that's the password we set as environment variable
$conn= new mysqli($host,$username,$pw);
if($conn->connect_errno> 0) {
    echo$db->connect_error;
} else {
    echo"DB Connection successful\n\n";

    //we read out the content
    $result=mysqli_query($conn,"SHOW DATABASES;");
    while( $row= mysqli_fetch_row( $result) ){
        echo$row[0]."\n";
    }
}
phpinfo();

