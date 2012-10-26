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
package deshki;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

public class DeshkiTree {

	public static void main(String[] args)
	{
		try {
			DeshkiTree dt = new DeshkiTree();
			dt.buildTree();
			
			System.out.println("Done.");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private Connection _connection;
	private PreparedStatement _addElement;
	
	public void buildTree() throws ClassNotFoundException, SQLException
	{
		Class.forName("com.mysql.jdbc.Driver");
		_connection = DriverManager.getConnection("jdbc:mysql://localhost/deshki?user=root&password=rootpass");
		_addElement = _connection.prepareStatement("SELECT add_element(?,?,?)");
		
		buildNext(-1, new Game(null, null));
		
		_addElement.close();
		_connection.close();
	}
	
	private void buildNext(int parent, Game game) throws SQLException
	{
		_addElement.setInt(1, parent);
		_addElement.setBytes(2, game.toBytes());
		_addElement.setInt(3, game.getLastMoveNumber()+1);
		
		ResultSet rs = _addElement.executeQuery();
		rs.first();
		int id = rs.getInt(1);
		rs.close();
		
		if(game.getState()!=GameState.IN_PROGRESS) {
			return;
		}
		
		Vector<Move> moves = game.getPossibleMoves();
		for(int i=0; i<moves.size(); ++i) {
			buildNext(id, new Game(game, moves.get(i)));
		}
	}

}
