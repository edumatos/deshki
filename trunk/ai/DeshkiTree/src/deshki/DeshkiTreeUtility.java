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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DeshkiTreeUtility {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		int level = 0;
		
		Connection connection = null;
		try {
			
			Class.forName("com.mysql.jdbc.Driver");
			connection = DriverManager.getConnection("jdbc:mysql://localhost/deshki?user=root&password=rootpass");
			
			Statement st = connection.createStatement();
			ResultSet rs = st.executeQuery("SELECT id,state FROM element WHERE level="+level);
			while(rs.next())
			{
				int id = rs.getInt(1);
				Game game = new Game(null,null);
				game.fromBytes(rs.getBytes(2));
				
				int utility = 0;
				if(game.getState()==GameState.EVEN_WON)
					utility = 16-level;
				else if(game.getState()==GameState.ODD_WON)
					utility = level-16;
				else if(game.getState()==GameState.DRAW)
					utility = 0;
				else
				{
					utility = level%2==0 ? -16 : 16;
					Statement children = connection.createStatement();
					ResultSet crs = children.executeQuery("SELECT element.utility FROM element INNER JOIN parent_child ON parent_child.child=element.id WHERE parent_child.parent = "+id);
					while(crs.next())
					{
						int tmp = crs.getInt(1);
						if(level%2==0)
						{
							if(tmp > utility)
								utility = tmp;
						}
						else
						{
							if(tmp < utility)
								utility = tmp;
						}
					}
					crs.close();
					children.close();
				}
				
				Statement ust = connection.createStatement();
				ust.executeUpdate("UPDATE element SET utility="+utility+" WHERE id="+id);
				ust.close();
			}
			rs.close();
			st.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			
			try {
				if(connection!=null)
					connection.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		System.out.println(level+" - Done");
	}

}
