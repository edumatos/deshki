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
import java.sql.Statement;

public class DeshkiTreeUtility {

	public static void main(String[] args) {
		
		for(int level=16; level>=0; --level)
			calcUtilityForLevel(level);
	}
	
	private static void calcUtilityForLevel(int level)
	{
		Connection connection = null;
		PreparedStatement selectChildren = null;
		PreparedStatement updateUtility = null;
		
		try {
			
			Class.forName("com.mysql.jdbc.Driver");
			connection = DriverManager.getConnection("jdbc:mysql://localhost/deshki?user=root&password=rootpass");
			
			selectChildren = connection.prepareStatement("SELECT element.utility FROM element INNER JOIN parent_child ON parent_child.child=element.id WHERE parent_child.parent=?");
			updateUtility = connection.prepareStatement("UPDATE element SET utility=? WHERE id=?");
			
			Statement selectLevel = connection.createStatement();
			ResultSet elements = selectLevel.executeQuery("SELECT id, state FROM element WHERE level="+level);
			while(elements.next())
			{
				int id = elements.getInt(1);
				Game game = new Game(null,null);
				game.fromBytes(elements.getBytes(2));
				
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
					selectChildren.setInt(1, id);
					ResultSet children = selectChildren.executeQuery();
					while(children.next())
					{
						int childUtility = children.getInt(1);
						if(level%2==0)
						{
							if(childUtility > utility)
								utility = childUtility;
						}
						else
						{
							if(childUtility < utility)
								utility = childUtility;
						}
					}
					children.close();
				}
				updateUtility.setInt(1, utility);
				updateUtility.setInt(2, id);
				updateUtility.executeUpdate();
			}
			elements.close();
			selectLevel.close();
			
			System.out.println(level+" - Done");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(selectChildren!=null)
					selectChildren.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			try {
				if(updateUtility!=null)
					updateUtility.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			try {
				if(connection!=null)
					connection.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

}
