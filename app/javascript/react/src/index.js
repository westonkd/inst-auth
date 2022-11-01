import { define } from "remount";
import Hello from "./components/Hello";
import Authorization from "./components/Authorization"

define({ "hello-component": Hello });
define({"authorization-component": Authorization})
