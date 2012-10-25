<?php

/*
* Игра Дешки
* Copyright (C) 2012  Павел Кабакин
* 
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
* 
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* 
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

header("Content-Type: application/octet-stream");
$bytes = file_get_contents('php://input');

mysql_connect('localhost', 'root', 'rootpass');
mysql_select_db('deshki');

$result = mysql_query('SELECT ce.state FROM element pe, element ce INNER JOIN parent_child ON parent_child.child=ce.id WHERE pe.id=parent_child.parent AND pe.state=UNHEX("'.bin2hex($bytes).'") AND pe.utility=ce.utility');
if(!$result)
{
	exit();
}
$states = array();
while($row = mysql_fetch_array($result))
{
	array_push($states, $row['state']);
}
if(count($states)==0)
{
	exit();
}
echo $states[array_rand($states)];

?>