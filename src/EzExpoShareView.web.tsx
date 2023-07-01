import * as React from 'react';

import { EzExpoShareViewProps } from './EzExpoShare.types';

export default function EzExpoShareView(props: EzExpoShareViewProps) {
  return (
    <div>
      <span>{props.name}</span>
    </div>
  );
}
