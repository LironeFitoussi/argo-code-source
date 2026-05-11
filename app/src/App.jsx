import React from 'react'

const dummyData = [
  { id: 1, name: 'Item 1' },
  { id: 2, name: 'Item 2' },
  { id: 3, name: 'Item 3' },
]
export default function App() {
  return (
    <div style={{ fontFamily: 'sans-serif', textAlign: 'center', marginTop: '4rem' }}>
      <h1>React App</h1>
      <p>Running in Kubernetes</p>
      <div style={{ marginTop: '2rem' }}>
        <a href="www.google.com" target="_blank" rel="noopener noreferrer">
          Visit Google
        </a>
        {dummyData.map(item => (
          <p key={item.id}>{item.name}</p>
        ))}
      </div>
    </div>
  )
}
