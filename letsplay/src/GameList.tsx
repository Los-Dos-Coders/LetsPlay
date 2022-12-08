import useSWR from 'swr';
import axios from 'axios';
import React from 'react';

interface Game {
  name: string;
  genre: string;
  coopCount: number;
  multiplayerCount: number;
}

const GameList = (): JSX.Element => {
  const fetcher = (url: string) => axios.get(url).then(res => res.data);
  const {data, error} = useSWR('/games', fetcher);

  if (error) return <div>Failed to load</div>;
  if (!data) return <div>Loading...</div>;
  return (
    <div className="GameList">
      <h2>Games</h2>
      {data.map((game: Game) => (
        <p key={game.name}>{game.name}</p>
      ))}
    </div>
  );
};
export default GameList;
