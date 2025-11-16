import { type RenderOptions, render } from '@testing-library/react';
import type { ReactElement } from 'react';

// カスタムレンダー関数（将来的にProviderを追加可能）
function customRender(ui: ReactElement, options?: Omit<RenderOptions, 'wrapper'>) {
  return render(ui, { ...options });
}

export * from '@testing-library/react';
export { customRender as render };
