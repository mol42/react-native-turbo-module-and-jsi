import type {TurboModule} from 'react-native/Libraries/TurboModule/RCTExport';
import {TurboModuleRegistry} from 'react-native';

export interface Spec extends TurboModule {
  add(a: number, b: number): Promise<number>;
  addSync(a: number, b: number): number;
  runC42VMSync(): number;
}

export default TurboModuleRegistry.get<Spec>(
  'RTNCalculator',
) as Spec | null;