import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to EzExpoShare.web.ts
// and on native platforms to EzExpoShare.ts
import EzExpoShareModule from './EzExpoShareModule';
import { ChangeEventPayload } from './EzExpoShare.types';

const emitter = new EventEmitter(EzExpoShareModule ?? NativeModulesProxy.EzExpoShare);

export function addChangeListener(listener: (event: ChangeEventPayload) => void): Subscription {
  return emitter.addListener<ChangeEventPayload>('onChange', listener);
}

export { ChangeEventPayload };
