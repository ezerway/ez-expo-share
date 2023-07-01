import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to EzExpoShare.web.ts
// and on native platforms to EzExpoShare.ts
import EzExpoShareModule from './EzExpoShareModule';
import EzExpoShareView from './EzExpoShareView';
import { ChangeEventPayload, EzExpoShareViewProps } from './EzExpoShare.types';

// Get the native constant value.
export const PI = EzExpoShareModule.PI;

export function hello(): string {
  return EzExpoShareModule.hello();
}

export async function setValueAsync(value: string) {
  return await EzExpoShareModule.setValueAsync(value);
}

const emitter = new EventEmitter(EzExpoShareModule ?? NativeModulesProxy.EzExpoShare);

export function addChangeListener(listener: (event: ChangeEventPayload) => void): Subscription {
  return emitter.addListener<ChangeEventPayload>('onChange', listener);
}

export { EzExpoShareView, EzExpoShareViewProps, ChangeEventPayload };
