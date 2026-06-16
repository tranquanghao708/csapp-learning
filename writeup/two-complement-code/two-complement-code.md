# CSAPP : mã bù hai và tràn số

**mục lục**

- 1.[Mã bù hai](#mã-bù-hai)

	- 1.1.Mã bù hai là gì ?

	- 1.2.Cách đọc bit parrent sang số nguyên ?

	- 1.3.Miền giá trị biểu diễn được

	- 1.3.1.Áp dụng thử vào C

	- 1.3.2.Debug chương trình C

	- 1.4.Chuyển đổi giữa unsigned và signed

	- 1.5.Vì sao gọi là mã bù hai?

- 2.Tràn số

# Mã bù hai

**1.1.Mã bù hai là gì?**

- Mã bù hai Bit MSB có trọng số `−2**(w−1)` , các bit còn lại có trọng số dương như bình thường

- là cách biểu diễn signed của trọng số MSB luôn là số âm. Nghĩa là, nếu `MSB = 1` đó là số âm còn `MSB = 0` thuộc miền không âm (số 0) hoặc dương

**1.2. Cách đọc bit parrent sang số nguyên ?**

![alt text](image0.png)

> trích từ sách CS:APP

chúng ta thấy có cái `SIGMA`, đó là công thức tính giá trị của một cái đoạn nhị phân signed ra số nguyên. Nghĩa là, 1 đoạn nhị phân `0001` ra số nguyên là `1` nhưng đoạn `1001` lại ra `-1` tại sao?

- Do tôi không biết tính sigma, đơn giản là tôi chưa học tới chương trình đó nên tôi sẽ thực hiện tính nhị phân theo cái cách mà tôi được học như sau :

giả sử tôi có một đoạn nhị phân 13 bit signed có MSB là 1 : `1001001100010`

và một đoạn nhị phân 12 bit signed nhưng lại có MSB là 0 : `011011000100`

vậy tôi sẽ tính toán nó để xem result của nó về số nguyên là gì :


với đoạn nhị phân 1 là `1001001100010` ta lập bảng :

| Bit vị trí | 12 | 11 | 10 | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
|------------|----|----|----|---|---|---|---|---|---|---|---|---|---|
| bit        | 1  | 0  | 0  | 1 | 0 | 0 | 1 | 1 | 0 | 0 | 0 | 1 | 0 |


Trọng số lần lượt các bit : -4096 (Số MSB) , 2048, 1024... 

- cứ thế chia 2 lần lượt tới bit LSB, hoặc đơn giản dùng lũy thừa:

 `2**N`

- trong đó :

	- `2` : là cái hệ cơ số của binary ý

	- `N` : là các vị trí bit

Ví dụ : `2**12 = 4096` (tại sao làm việc ở mức MSB signed mà tôi không thêm âm? do là mã bù hai bit MSB vốn đã có trọng số âm rồi) , bằng chứng cho kết quả :

![alt text](image1.png)

- Để tiết kiệm thời gian, tôi chỉ lấy những bit vị trí có bit là `1` thôi, bởi vì bit 1 mới có thể đem đi và cộng lại và bit 0 thì không thể cộng lại vì 0 là tắt rồi nó không hoạt động nữa nên chúng ta bỏ. Dựa trên bảng bit thì chúng ta có những vị trí và trọng số của các bit 1 :

| Bit vị trí | 12 | 9 | 6 | 5 | 1 |
|------------|----|---|---|---|---|
| Trọng số   |  -4096 | 512 | 64 | 32 | 2 |

![alt text](image2.png)

ta có lần lượt các trọng số bit 1 như sau : `-4096 , 512 , 64 , 32 , 2`

Và ta tiến hành cộng chúng lại để ra giá trị của chúng : `(-4096) + 512 + 64 + 32 + 2 = -3486` giá trị của bit `1001001100010` là `-3486`

![alt text](image3.png)

vậy còn số nhị phân `011011000100` ta lập bảng :

| Bit vị trí | 11 | 10 | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
|------------|----|----|---|---|---|---|---|---|---|---|---|---|
| số bit     | 0  | 1  | 1 | 0 | 1 | 1 | 0 | 0 | 0 | 1 | 0 | 0 |
|			 |    |    |   |   |   |   |   |   |   |   |   |   |
| Trọng số   | bỏ | 1024 | 512 | bỏ | 128 | 64 | bỏ | bỏ | bỏ | 4 | bỏ | bỏ |

![alt text](image4.png)

từ bảng ta có làn lượt là : `1024 , 512 , 128 , 64 và 4`

tính tổng lại : `1024 + 512 + 128 + 64 + 4 = 1732`

![alt text](image5.png)

**1.3.Miền giá trị biểu diễn được**

- Miền gía trị biểu diễn được là định nghĩa một dãy binary nó có thể chứa trọng số thấp nhất (MIN) và trọng số cao nhất (MAX) là bao nhiêu tính từ âm đến dương. Ví dụ với một dãy binary 4 bit :

4 bit có miền giá trị âm `1000` MSB = 1, tới dương `0111` MSB = 0 và để biết số nguyên nhỏ nhất và cao nhất thì ta có hai cách :

- 1. là chúng ta đếm thủ công hoặc là dịch binary ra ở các trang website, hoặc là dùng lệnh để dịch ra số nguyên

- 2. là chúng ta sử dụng biểu thức huyền thoại mà kiến trúc máy tính, CSAPP thường hay đề cập tới. Tính số nguyên cao nhất của binary 4 bit, ở đây tôi dùng công thức huyền thoại là `2**N-1`, nói sơ qua về công thức này thì:

	- `2` : là hệ cơ số của binary

	- `N` : là số lượng bit ví dụ ta muốn tính 4 bit như `0000 -> 1111` thì ta đưa số 4 vào

	- `-1` : bởi vì ta đếm từ số 0, nên N bit tạo ra hai giá trị khác nhau chênh lệch là 1.Nên giá trị lớn nhất của dãy binary là 2**N-1

Như thế công thức này dùng để tính giá trị của dãy nhị phân không dấu unsigned là `1111` nhưng chúng ta muốn tính dãy nhị phân có dấu signed là `0111` mà ? vậy thì chúng ta thực hiện trừ 1 thêm đi cho phép lũy thừa, phép toán chỉ xem và tính các dãy bit còn lại và không tính bit MSB , kết quả của biểu thức sẽ như vậy : `2**(N-1)-1`

Và chúng ta tiến hành thực hiện tính toán : `2**(N-1)-1 = 7` và giá trị 7 này chính là giá trị lớn nhất của hệ binary 4 bit

![alt text](image6.png)

vậy còn giá trị nhỏ nhất thì sao?

- Giá trị nhỏ nhất là phần mà bit MSB chạm 1, nghĩa là ta có `0111` là phần bit lớn nhất của số dương theo hệ có dấu signed rồi nhưng ta cộng 1 bit nữa là `1000` MSB = 1 , số âm là `-8` thì đó chính xác là phần nhỏ nhất rồi. Tương đương với công thức `-2**(N-1)`

vậy từ các phép tính trên thì miền giá trị là `[-8 , 7]` theo số nguyên

một vài lưu ý mà tôi được thẩm từ cuốn CSAPP là, miền giá trị theo hệ signed mã bù hai là **không đối xứng** ví dụ tôi có:

| miền giá trị 4 bit | -8 | -7 | -6 | -5 | -4 | -3 | -2 | -1 | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|--------------------|----|----|----|----|----|----|----|----|---|---|---|---|---|---|---|---|

tất nhiên theo bản, bạn thấy nó có 8 số âm và 8 số không âm nên là `TMin = -8` và `TMax = 7` vì sao bạn thấy có 8 số âm và không âm đều đều cả hai nhưng TMin và TMax lại có sự chênh lệch là 1 đơn vị ?

- **Bạn thấy số 0?** đó chính là lý do lớn nhất, số 0 theo hệ không âm nhưng lại không góp phần làm tăng giá trị bên dãy số dương nên TMax bị trừ 1

**1.3.1.Áp dụng thử vào C**

- Nếu như ở trên là lý thuyết?, chúng ta tiến hành viết một chương trình C nhỏ để có thể tính toán các dãy bit trên hệ thống thật . Do hệ thống thật là 64 bit nhưng trong C các kiểu dữ liệu nó có 1 cái hay là có riêng cho nó một lượng byte riêng ví dụ `2 byte` là `short`, chúng ta sẽ ứng dụng short vào trong chương trình này. Cứ dịch ra trước `2 byte là 16 bit` và tính toán TMin và TMax trước đi đã

Tmin của 16 bit = `-2**(N-1)` = -32768

Tmax của 16 bit = `2**(N-1)-1` = 32767

![alt text](image7.png)

```c
#include <stdio.h>

int main(void){
	short numbers = 32767; //là số Tmax của biến short 

	numbers += 1; //lúc này sẽ ra Tmin của short

	printf("%d\n",numbers);

	return 0;
}
```

![alt text](image8.png)

Nó hoạt động đúng như những gì mà sách nói cũng như kỳ vọng của tôi, ở đây theo chuẩn CPU hầu hết các thiết bị hiện đại thì nó đều dùng bù hai nên như bạn thấy trong ảnh là kết quả đúng là Tmin của 16bit, nhưng với theo cách nhìn của lập trình C điều này là UB vì phép toán này thuộc nhóm signed overflow

tương tự với nhiều kiểu dữ liệu có dấu khác:

| Kiểu        | Bit | Tmin                 | Tmax                |
| ----------- | --- | -------------------- | ------------------- |
| signed char | 8   | -128                 | 127                 |
| short       | 16  | -32768               | 32767               |
| int         | 32  | -2147483648          | 2147483647          |
| long long   | 64  | -9223372036854775808 | 9223372036854775807 |

**1.3.2.Debug chương trình C**

chúng ta cùng debug nó xem cái gì nó đang thực sự diễn ra bên trong.