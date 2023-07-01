import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import { EzExpoShareViewProps } from './EzExpoShare.types';

const NativeView: React.ComponentType<EzExpoShareViewProps> =
  requireNativeViewManager('EzExpoShare');

export default function EzExpoShareView(props: EzExpoShareViewProps) {
  return <NativeView {...props} />;
}
