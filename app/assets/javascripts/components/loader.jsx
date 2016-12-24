import React from 'react';

export default function Loader({ textOnly }) {
  if (textOnly) {
    return <div>Loading...</div>
  }

  return (
    <div className='loader'>
      <div className='spinner'>
        <div className='rect1'></div>
        <div className='rect2'></div>
        <div className='rect3'></div>
        <div className='rect4'></div>
        <div className='rect5'></div>
      </div>
    </div>
  );
}
