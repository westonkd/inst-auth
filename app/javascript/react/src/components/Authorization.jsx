import * as React from "react";
import {
  InstUISettingsProvider,
  canvas,
  Flex,
  Heading,
  SVGIcon,
  Text,
  Button,
  View,
  TextInput,
} from "@instructure/ui";

const Authorization = ({ tenant, connections }) => {
  return (
    <InstUISettingsProvider theme={canvas}>
      <Flex height="70vh" justifyItems="center" padding="large">
        <View background="primary">
          <Flex.Item shouldShrink shouldGrow textAlign="center">
            <Heading level="h1" margin="0 0 medium">
              Welcome
            </Heading>

            <View display="block" margin="none none small none">
              <Text>Please sign into {tenant}</Text>
            </View>

            <View display="block" width="300px">
              <form>
                <View display="block" margin="small none">
                  <TextInput renderLabel="Username" />
                </View>
                <View display="block" margin="none none small none">
                  <TextInput renderLabel="Password" type="password" />
                </View>
                <View display="block">
                  <Button color="primary" display="block" type="submit">
                    Continue
                  </Button>
                </View>
              </form>
            </View>

            <View display="block" margin="medium none">
              <Text>- OR -</Text>
            </View>

            <View display="block" width="300px">
              {connections.map((connection) => (
                  <View display="block" key={connection.identifier}>
                    <Button color="secondary" display="block" type="submit" onClick={() => {
                      window.location.replace(connection.authorization_url);
                    }}>
                      Sign in with { connection.name }
                    </Button>
                  </View>
              ))}
            </View>
          </Flex.Item>
        </View>
      </Flex>
    </InstUISettingsProvider>
  );
};

export default Authorization;
