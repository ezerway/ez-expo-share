import { StyleSheet, Text, View } from 'react-native';

import * as EzExpoShare from 'ez-expo-share';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>{EzExpoShare.hello()}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
