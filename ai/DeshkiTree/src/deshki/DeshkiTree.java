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

	/**
	 * @param args
	 */
	public static void main(String[] args)
	{
		DeshkiTree dt = new DeshkiTree();
		try {
			dt.buildTree();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private Connection _connection;
	
	public DeshkiTree()
	{
		
	}
	
	public void buildTree() throws ClassNotFoundException, SQLException
	{
		Class.forName("com.mysql.jdbc.Driver");
		_connection = DriverManager.getConnection("jdbc:mysql://localhost/deshki?user=root&password=rootpass");
		buildNext(-1, new Game(null, null));
		_connection.close();
		
		System.out.println("Done.");
	}
	
	private void buildNext(int parent, Game game) throws SQLException
	{
		/*
		BEGIN
   		DECLARE lastInsertId integer;
   		INSERT INTO element (state,level) VALUES (state_param,level_param) ON DUPLICATE KEY UPDATE id=LAST_INSERT_ID(id);
   		SET lastInsertId = LAST_INSERT_ID();
   		INSERT IGNORE INTO parent_child (parent,child) VALUES (parent_param,lastInsertId);
   		RETURN lastInsertId;
   		END
   		*/
		PreparedStatement st = _connection.prepareStatement("SELECT add_element(?,?,?)");
		st.setInt(1, parent);
		st.setBytes(2, game.toBytes());
		st.setInt(3, game.getLastMoveNumber()+1);
		ResultSet rs = st.executeQuery();
		rs.first();
		int id = rs.getInt(1);
		rs.close();
		st.close();
		
		if(game.getState()==GameState.EVEN_WON || game.getState()==GameState.ODD_WON || game.getState()==GameState.DRAW)
		{
			return;
		}
		
		Vector<Move> moves = game.getPossibleMoves();
		for(int i=0; i<moves.size(); ++i)
		{
			buildNext(id, new Game(game, moves.get(i)));
		}
	}

}
