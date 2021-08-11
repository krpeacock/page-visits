export const idlFactory = ({ IDL }) => {
  const Route = IDL.Text;
  const Time = IDL.Int;
  const DeviceType = IDL.Variant({ 'Desktop' : IDL.Null, 'Mobile' : IDL.Null });
  const VisitRecord = IDL.Record({ 'time' : Time, 'deviceType' : DeviceType });
  const VisitSummary = IDL.Record({
    'total' : IDL.Nat32,
    'desktop' : IDL.Nat32,
    'time' : Time,
    'mobile' : IDL.Nat32,
    'route' : Route,
  });
  const Error = IDL.Variant({ 'NotFound' : IDL.Null });
  const Result_1 = IDL.Variant({ 'ok' : VisitSummary, 'err' : Error });
  const Result = IDL.Variant({ 'ok' : IDL.Null, 'err' : Error });
  return IDL.Service({
    'getKeys' : IDL.Func([], [IDL.Vec(Route)], ['query']),
    'getLogs' : IDL.Func([], [IDL.Vec(VisitRecord)], ['query']),
    'getSummary' : IDL.Func([Route], [Result_1], ['query']),
    'log' : IDL.Func([Route, DeviceType], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
