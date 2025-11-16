import { Button } from './components/common/Button';

function App() {
  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">Twitter Clone</h1>
        <p className="text-gray-600 mb-6">React + Vite + TypeScript + Tailwind CSS</p>
        <Button variant="primary" size="lg">
          Get Started
        </Button>
      </div>
    </div>
  );
}

export default App;
