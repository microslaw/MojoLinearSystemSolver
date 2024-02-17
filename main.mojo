from memory.unsafe import DTypePointer


trait Iterable:
   fn __len__(self) -> Int:
      pass

   # declaration below too restrictive
   fn __getitem__(self, index : Int) -> Int:
      pass


struct Vector[DataType: DType]:
   var size : Int
   var data : DTypePointer[DataType]

   fn __init__(inout self : Vector[DataType], size : Int):
      self.size = size
      self.data = DTypePointer[DataType].alloc(size)
      memset_zero(self.data, size)

   fn __copyinit__(inout self : Vector[DataType], other : Vector[DataType]):
      self.size = other.size
      self.data = DTypePointer[DataType].alloc(other.size)
      memcpy(self.data, other.data, other.size)

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


   fn __str__(borrowed self : Vector[DataType]) -> String:
      var result :String = "["
      for i in range(self.size):
         result = result + String(self.data[i].to_int())
         if i < self.size - 1:
            result = result + ", "
      result = result + "]"
      return result

   fn print(borrowed self : Vector[DataType]):
      print(self.__str__())

struct Matrix[DataType: DType]:
   var rows : Int
   var cols : Int
   var data : DTypePointer[DataType]

   fn __init__(inout self : Matrix[DataType], rows : Int, cols : Int):
      self.rows = rows
      self.cols = cols
      self.data = DTypePointer[DataType].alloc(rows * cols)
      memset_zero(self.data, rows * cols)

   fn __copyinit__(inout self : Matrix[DataType], other : Matrix[DataType]):
      self.rows = other.rows
      self.cols = other.cols
      self.data = DTypePointer[DataType].alloc(other.rows * other.cols)
      memcpy(self.data, other.data, other.rows * other.cols)

   fn __setitem__(inout self : Matrix[DataType], row : Int, col : Int, value : SIMD[DataType, 1]):
      self.data[row * self.cols + col] = value

   fn __getitem__(borrowed self : Matrix[DataType], row : Int, col : Int) -> SIMD[DataType, 1]:
      return self.data[row * self.cols + col]

   fn get_col(borrowed self : Matrix[DataType], col : Int) -> Vector[DataType]:
      var result = Vector[DataType](self.rows)
      for i in range(self.rows):
         result[i] = self.data[i * self.cols + col]
      return result

   fn get_row(borrowed self : Matrix[DataType], row : Int) -> Vector[DataType]:
      var result = Vector[DataType](self.cols)
      for i in range(self.cols):
         result[i] = self.data[row * self.cols + i]
      return result

   fn __str__(borrowed self : Matrix[DataType]) -> String:
      var result :String = "["
      for i in range(self.rows):
         result = result + "["
         for j in range(self.cols):
            result = result + String(self.data[i * self.cols + j].to_int())
            if j < self.cols - 1:
               result = result + ", "
         result = result + "]"
         if i < self.rows - 1:
            result = result + ", "
      result = result + "]"
      return result

   fn print(borrowed self : Matrix[DataType]):
      print(self.__str__())


fn main():

   var v = Vector[DType.int8](10)
   v[1] = 9
   v.print()
   print(v[1])
