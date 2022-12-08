import {createServer, Model} from 'miragejs';

interface Game {
  name: string;
  genre: string;
  coopCount: number;
  multiplayerCount: number;
}

const startMirage = () => {
  return createServer({
    models: {
      game: Model,
    },
    routes() {
      this.resource('game');
      this.get('/games', (): Array<Game> => {
        return [
          {
            name: 'Gears of War',
            genre: 'action',
            coopCount: 4,
            multiplayerCount: 0,
          },
          {
            name: 'Hollow Knight',
            genre: 'rpg',
            coopCount: 0,
            multiplayerCount: 0,
          },
        ];
      });
    },
  });
};
export default startMirage;
