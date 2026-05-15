unit Core.Database.DBTypes;

interface

type
  TOperatorType = (OtEqual,otDifferent,otBigger,otBiggerEqual,otMinor,
                   otMinorEqual,otLikeFirst,otLikeLast,otLikeBoth,otIsNull,otIsNotNull);

const
  cOperator: array[TOperatorType] of string = ('=','<>','>','>=','<','<=','LIKE','LIKE','LIKE','Is Null','Is Not Null');

implementation

end.
