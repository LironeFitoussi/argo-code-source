import { render, screen } from '@testing-library/react'
import { describe, it, expect } from 'vitest'
import App from './App'

describe('App', () => {
  it('renders heading', () => {
    render(<App />)
    expect(screen.getByText('React App')).toBeTruthy()
  })

  it('renders kubernetes text', () => {
    render(<App />)
    expect(screen.getByText('Running in Kubernetes')).toBeTruthy()
  })
})
