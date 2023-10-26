/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */
import React from 'react';
import {useState} from 'react';
import {SafeAreaView, StatusBar, Text, Button} from 'react-native';
import RTNCalculator from 'rtn-calculator/js/NativeCalculator';

const App: () => JSX.Element = () => {
  const [result, setResult] = useState<number | null>(null);
  console.log('RTNCalculator', RTNCalculator);
  console.log('RTNCalculator.addSync', RTNCalculator?.addSync);
  return (
    <SafeAreaView>
      <StatusBar barStyle={'dark-content'} />
      <Text style={{marginLeft: 20, marginTop: 20}}>3+7={result ?? '??'}</Text>
      <Button
        title="Compute"
        onPress={async () => {
          // const value = await RTNCalculator?.add(3, 7);
          const value = RTNCalculator?.addSync(3, 8);
          console.log('value', value);
          setResult(value ?? null);
        }}
      />
    </SafeAreaView>
  );
};
export default App;