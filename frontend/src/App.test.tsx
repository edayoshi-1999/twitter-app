import App from './App';
import { render, screen } from './test/utils';

describe('App', () => {
  it('renders the app title', () => {
    render(<App />);
    expect(screen.getByText('Twitter Clone')).toBeInTheDocument();
  });

  it('renders the subtitle', () => {
    render(<App />);
    expect(screen.getByText(/React \+ Vite \+ TypeScript \+ Tailwind CSS/i)).toBeInTheDocument();
  });

  it('renders the get started button', () => {
    render(<App />);
    expect(screen.getByRole('button', { name: 'Get Started' })).toBeInTheDocument();
  });
});
