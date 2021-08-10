import type { Principal } from '@dfinity/principal';
export type DeviceType = { 'Desktop' : null } |
  { 'Mobile' : null };
export type Error = { 'NotFound' : null };
export type Result = { 'ok' : null } |
  { 'err' : Error };
export type Result_1 = { 'ok' : VisitSummary } |
  { 'err' : Error };
export type Route = string;
export type Time = bigint;
export interface VisitRecord { 'time' : Time, 'deviceType' : DeviceType }
export interface VisitSummary {
  'total' : number,
  'desktop' : number,
  'time' : Time,
  'mobile' : number,
  'route' : Route,
}
export interface _SERVICE {
  'getLogs' : () => Promise<Array<VisitRecord>>,
  'getSummary' : (arg_0: Route) => Promise<Result_1>,
  'log' : (arg_0: Route, arg_1: DeviceType) => Promise<Result>,
}
