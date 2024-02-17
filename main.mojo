from memory.unsafe import DTypePointer


# trait Iterable:
#    fn __len__(self) -> Int:
#       pass

#    # declaration below too restrictive
#    fn __getitem__(self, index : Int) -> Int:
#       pass


struct Vector[DataType: DType]:
   var size : Int
   var data : DTypePointer[DataType]

   fn __init__(inout self : Vector[DataType], size : Int):
      self.size = size
      self.data = DTypePointer[DataType].alloc(size)
      memset_zero(self.data, size)

   # fn __init__( inout self : Vector[DataType], listLike: Iterable):
   #    self.size = listLike.__len__()
   #    self.data = DTypePointer[DataType].alloc(self.size)

   #    #enumerate isn't implemented yet
   #    for i in range(self.size):
   #       self.__setitem__(i,listLike.__getitem__(i))

   fn __setitem__(inout self : Vector[DataType], index : Int, value : SIMD[DataType, 1]):
      self.data[index] = value

   fn __getitem__(borrowed self : Vector[DataType], index : Int) -> SIMD[DataType, 1]:
      return self.data[index]

fn main():
   var v = Vector[DType.int8](10)

   var x = v[0]
   print(x)
