using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using PlayerIO.GameLibrary;
using System.Drawing;

namespace Deshki {
	public class Player : BasePlayer {
        public int time;
	}

	[RoomType("Deshki")]
	public class GameCode : Game<Player> {

        private GameModel _gameModel;
        private Player _evenPlayer;
        private Player _oddPlayer;
        private int _time;
        private Timer _timer;
        private const int TOTAL_TIME = 5 * 60 * 1000;
		
		public override void GameStarted() {
            _gameModel = new GameModel();
		}

		public override void GameClosed() {
		}

        public override bool AllowUserJoin(Player player)
        {
            return PlayerCount<2;
        }

		public override void UserJoined(Player player) {
            SendUserList(player);
            SendToAllExceptOne(player, "UserJoined", player.Id, player.ConnectUserId);

            if (_evenPlayer == null)
                _evenPlayer = player;
            else if (_oddPlayer == null)
                _oddPlayer = player;

            if (_evenPlayer != null && _oddPlayer != null)
            {
                _gameModel.Reset();

                _evenPlayer.time = _oddPlayer.time = 0;
                _time = GetTime();
                _timer = ScheduleCallback(TimerCallback, TOTAL_TIME);

                Broadcast("Start", _evenPlayer.Id, _oddPlayer.Id);
            }
		}

		public override void UserLeft(Player player) {
            Broadcast("UserLeft", player.Id);

            if (_evenPlayer == player)
                _evenPlayer = null;
            else if (_oddPlayer == player)
                _oddPlayer = null;

            if (_evenPlayer == null || _oddPlayer == null)
            {
                if(_timer!=null)
                    _timer.Stop();
                Broadcast("Stop");
            }
		}

		public override void GotMessage(Player player, Message message) {
			switch(message.Type) {
                case "ChatMessage":
                    Broadcast("ChatMessage", player.Id, message.GetString(0));
                    break;
                case "Move":
                    HandleMove(player, message);
                    break;
			}
		}

        private void HandleMove(Player player, Message message)
        {
            if (_evenPlayer==null || _oddPlayer==null)
                return;
            if (message.Count != 2)
                return;
            Player current;
            Player next;
            if ((_gameModel.LastMoveNumber + 1) % 2 == 0)
            {
                current = _evenPlayer;
                next = _oddPlayer;
            }
            else
            {
                current = _oddPlayer;
                next = _evenPlayer;
            }
            if (current != player)
                return;
            int x = message.GetInt(0);
            int y = message.GetInt(1);
            if (_gameModel.CanMove(x, y))
            {
                _timer.Stop();
                int t = GetTime();
                current.time += t - _time;
                _time = t;

                _gameModel.DoMove(x, y);

                if (_gameModel.CurrentState == GameModel.State.IN_PROGRESS)
                   _timer = ScheduleCallback(TimerCallback, Math.Max(TOTAL_TIME - next.time, 0));

                Broadcast(message);
            }
        }

        private void TimerCallback()
        {
            _gameModel.Stop();
            Broadcast("TimeIsUp");
        }

        private int GetTime()
        {
            return Convert.ToInt32((DateTime.Now - new DateTime(2012, 1, 1)).TotalMilliseconds);
        }

        private void SendUserList(Player player)
        {
            Message m = Message.Create("UserList");
            m.Add(player.Id);
            foreach (Player p in Players)
            {
                m.Add(p.Id, p.ConnectUserId);
            }
            player.Send(m);
        }

        private void SendToAllExceptOne(Player player, Message m)
        {
            foreach (Player p in Players)
            {
                if (p != player)
                {
                    p.Send(m);
                }
            }
        }

        private void SendToAllExceptOne(Player player, string type, params object[] parameters)
        {
            foreach (Player p in Players)
            {
                if (p != player)
                {
                    p.Send(type, parameters);
                }
            }
        }
	}

    public class GameModel
    {
        public enum State
        {
            EVEN_WON,
            ODD_WON,
            DRAW,
            IN_PROGRESS
        }

        private List<bool> _field;
        private List<int> _history;
        private State _state;

        public GameModel()
        {
            _field = new List<bool> { false, false, false, false,
                false, false, false, false,
                false, false, false, false,
                false, false, false, false };
            _history = new List<int>(16);
            _state = State.IN_PROGRESS;
        }

        public State CurrentState { get { return _state; } }

        public int LastMoveNumber { get { return _history.Count - 1; } }

        public void Reset()
        {
            for (int i = 0; i < _field.Count; ++i)
            {
                _field[i] = false;
            }
            _history.Clear();
            _state = State.IN_PROGRESS;
        }

        public void Stop()
        {
            _state = (_history.Count - 1) % 2 == 0 ? State.EVEN_WON : State.ODD_WON;
        }

        public bool CanMove(int x, int y)
        {
            if(_state!=State.IN_PROGRESS || (x<0 || x>=4 || y<0 || y>=4) || _field[y*4+x])
				return false;
			if(_history.Count>0)
			{
				int xor = _history[_history.Count-1]^(y*4+x);
				if(!(xor==1 || xor==2 || xor==4 || xor==8))
					return false;
			}
            return true;
        }

        public void DoMove(int x, int y)
        {
            _field[y * 4 + x] = true;
            _history.Add(y * 4 + x);

            if (_history.Count == 16)
            {
                _state = State.DRAW;
            }
            else if (!CanMove(x - 2, y) &&
                !CanMove(x - 1, y) &&
                !CanMove(x + 1, y) &&
                !CanMove(x + 2, y) &&
                !CanMove(x, y - 2) &&
                !CanMove(x, y - 1) &&
                !CanMove(x, y + 1) &&
                !CanMove(x, y + 2))
            {
                _state = (_history.Count - 1) % 2 == 0 ? State.EVEN_WON : State.ODD_WON;
            }
        }
    }
}
