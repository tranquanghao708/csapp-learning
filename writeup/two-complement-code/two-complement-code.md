# CSAPP : mã bù hai và tràn số

**mục lục**

- 1.[Mã bù hai](#mã-bù-hai)

	- 1.1.Mã bù hai là gì ? (Two's Complement Encodings, 2.2.3 trang 99,100)

	- 1.2.Cách đọc bit parrent sang số nguyên ? (Unsigned Encodings, 2.2.2 trang 97,98)

	- 1.3.Miền giá trị biểu diễn được

	- 1.3.1.Áp dụng thử vào C

	- 1.3.2.Debug chương trình C

	- 1.4.Chuyển đổi giữa unsigned và signed (Conversions Between Signed and Unsigned, 2.2.4 trang 105,106)

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

Nó hoạt động đúng như những gì mà sách nói cũng như kỳ vọng của tôi

> [!NOTE]
> Ghi chú : ở đây theo chuẩn CPU hầu hết các thiết bị hiện đại thì nó đều dùng bù hai nên như bạn thấy trong ảnh là kết quả đúng là Tmin của 16bit, nhưng với theo cách nhìn của lập trình C điều này là UB vì phép toán này thuộc nhóm signed overflow

tương tự với nhiều kiểu dữ liệu có dấu khác:

| Kiểu        | Bit | Tmin                 | Tmax                |
| ----------- | --- | -------------------- | ------------------- |
| signed char | 8   | -128                 | 127                 |
| short       | 16  | -32768               | 32767               |
| int         | 32  | -2147483648          | 2147483647          |
| long long   | 64  | -9223372036854775808 | 9223372036854775807 |

**1.3.2.Debug chương trình C**

chúng ta cùng debug nó xem cái gì nó đang thực sự diễn ra bên trong. Ở đây, chúng ta dùng công cụ GDB để debug từng dòng assemly :

> gdb -q test_type

và

> start

xong lệnh start nó sẽ thực thi tới đầu main nếu program còn symbol và chưa bị strip hoàn toàn 

![alt text](image9.png)

ở đoạn disassembly, chúng ta thấy pwndbg nó có hiện sẵn các vaddr và hexdecimal, tính cộng như trong ảnh

![alt text](image10.png)

để có bằng chứng chương trình thực hiện đúng cơ chế và lý thuyết y như CSAPP nói và output thì chúng ta soi kỹ cách disassembly được đưa ra từ gdb nó cộng lại như thế nào và hoạt động nhị phân nó ra làm sao ở đây dựa trên các đoạn hợp ngữ trong ảnh, chúng ta chú ý tới phần này :

```asm
   0x555555555147 <main+14>    movzx  eax, word ptr [rbp - 2]        EAX, [0x7fffffffe54e] => 0x7fff
   0x55555555514b <main+18>    add    eax, 1                         EAX => 0x8000 (0x7fff + 0x1)
   0x55555555514e <main+21>    mov    word ptr [rbp - 2], ax         [0x7fffffffe54e] <= 0x8000
```

ở đây tại instrution `0x5147` ta thấy thanh ghi eax hiện tại đang chứa `0x7fff` chính là Tmax của kiểu dữ liệu 16 bit, để kết luận 0x7fff chính xác là Tmax thì ta có bằng chứng như sau :

![alt text](image11.png)

bạn nhìn thấy nó là một dãy `111111111111111` và hiểu lầm MSB = 1 rồi mà đúng không? thực chất là chưa, giờ đây tới lượt instrution `0x514e` ta thấy sau khi nó cộng một đơn vị thì nó có giá trị `0x8000` đó chính là Tmin của binary 16bit, chứng minh nó là Tmin ta có bằng chứng như sau: 

![alt text](image12.png)

giờ đây bạn thấy điều gì lạ không, chúng ta lấy output ở ảnh 0x8000 là `1000000000000000` đi so sánh với ảnh trước là `111111111111111`, bạn thấy nó chênh lệch 1 đơn vị và phần `111111111111111` nó thấp hơn 1 đơn vị. Để dễ dàng cho việc so sánh tôi sẽ sắp xếp nó và thêm số 0 vào cho chuẩn 16 bit  :

| Tmax |0111111111111111|
|------|----------------|
| Tmin |1000000000000000|

- Bạn thấy MSB của cả hai bị chênh lệch 1 đơn vị, và bây giờ chúng ta `ni` tiếp tới printf() được gọi xem cái gì diễn ra

![alt text](image13.png)

chúng ta thấy có một điểm lạ, tại sao nó lại thêm `0xffff` vào ?

> đoạn này giải thích câu hỏi và thiên hướng về C có thể hơi ngoài lệ, bạn có thể bỏ qua nếu không quan tâm tới

<details>
	<summary>Lý do C lại thêm 0xffff</summary>

- Bởi vì trong C có cơ chế interger promotion, khi ta truyền type short vào printf, nó sẽ tự động ép sang kiểu int. Mà, tại vì sao nó phải làm vậy?

**trước hết chúng ta phải hiểu variadic function trong C là gì đã**

- Variadic function trong C, có tác dụng nhận các tham số không cố định, thường được khai báo trong các tập tin tiêu đề header (.h) thường ở các thư viện, nhận diện chúng bằng cách thấy ký hiệu `...` ở các slot argument kế tiếp. Mục đích của cái này là tiếp nhận tất cả biến có kiểu dữ liệu khác nhau, ví dụ hình hài của nó theo tiêu đề được khai báo sẵn trong hệ thống linux :

![alt text](image14.png)

> gọn hơn : dấu ... nghĩa là sau các tham số cố định, có thể truyền thêm bao nhiêu đối số tùy ý.

Nếu như thế thì nó liên quan gì tới việc thêm 0xffff vào vaddr?

- Khi ta truyền short vào printf, nó không biết đó là short nó chỉ biết một đống đối số sau `const char` và chuẩn C quy định, trước khi truyền vào hàm variadic thì các kiểu dữ liệu sau bị ép sang int :

| các type bị ép sang int |
|-------------------------|
| signed char | 
| unsigned char | 
| unsigned short |
| char |
| short |

Còn float thì bị ép thành double. Vậy ép xong rồi sao nó thêm `ffff`?

- phải nhắc tới `sign extension` ở đây. Chúng ta cần biết sign extension là sao đã, nó là một loại có thể kéo các dải bit khi thực hiện tăng các bit lên, dễ hiểu hơn là tôi sẽ cho một bảng như sau :

| bit gốc 		 | 1000 | 100 | 10 |
|----------------|------|-----|----|
| bit được tăng độ rộng toán hạng | 00001000 | 0000100 | 000010 |
| sign extension | 11111000 | 1111100 | 111110 |

ví dụ tôi cho nó là kiểu `a` đi, kiểu `a` có 4 bit là `0000 -> 1111`, bây giờ tôi cho kiểu `a` có giá trị là `Tmin = -2**(N-1)` là `1000` đó là hình hài bit của nó. Vậy khi kiểu `a` tôi ép kiểu nó sang kiểu `b` và kiểu b 8 bit (gấp đôi bit kiểu a) thì lúc này độ rộng toán hạng của nó là `11111000`. Đó là lý do đợt chạy debug vừa rồi nó thêm `0xffff` vì kiểu `short` theo quy định của C nó được ép sang kiểu `int` mà int gấp đôi short là 4 byte trong khi short có 2 byte thôi 

điều kiện để sign extension nó làm việc là MSB = 1 còn nếu MSB = 0 thì đó là của zero extension làm việc, nếu sign nó kéo dài với bit 1 thì zero kéo dài với bit 0 thôi

</details>

chúng ta tiếp tục `ni` và output sẽ giống y chang :

![alt text](image15.png)

vì đơn giản đó là Tmin theo signed, và khi MSB = 1 rồi thì mọi con số đều là âm hết nếu theo hệ bù hai signed 

**1.4.Chuyển đổi giữa unsigned và signed**

- Mọi binary ví dụ `11111111` đều có thể được diễn giải khác nhau tùy kiểu dữ liệu, bù hai signed diễn giải nó là `-1` nhưng theo unsigned nó là `255` nhưng bit nó vẫn là `11111111` không thay đổi ở bậc nhị phân, chỉ có cách diễn giải mới là bậc thay đổi vì thế gía trị cũng thay đổi theo

- chỉ là diễn giải cách đọc khác nhau khi làm việc với bit. Ví dụ :

ta có số `10` bây giờ hãy đọc nó theo hệ thập phân `mười` nhưng đọc nó theo hệ nhị phân `hai` số đó vẫn là `10` không chỉnh gì thêm chỉ khác cách đọc. Cách sát hơn nữa là `unsigned` và `signed`, ta có bảng so sánh như sau :

|binary | 11111111 | 10000001 | 10 |
|-------|----------|----------|----|
| signed | -1 | -127 | -2 |
| unsigned | 255 | 129 | 2 |

dựa theo bảng, chúng ta có thể thấy bit vẫn là bit, nó vẫn giữ nguyên đó không chỉnh sửa. Nhưng, giá trị bị thay đổi bởi vì 2 cách đọc hệ khác nhau 

- Ở trong sách CS:APP, người ta còn đề cập tới là chuyển đổi kiểu đọc giữa unsigned và signed

![alt text](image16.png)

nhìn vào dòng mã mà họ đưa trong sách :

```c
For example, consider the following code:

 	short int v = -12345;
 	unsigned short uv = (unsigned short) v;
	printf("v = %d, uv = %u\n", v, uv);
```

> When run on a two’s-complement machine, it generates the following output:

> v = -12345, uv = 53191

Chúng ta có thể hiểu theo minh họa là, khi ta khai báo cái biến `v` với số âm = -12345 thì nó vẫn là số âm, nhưng khi ta ép nó sang unsigned là `unsigned short uv = (unsigned short) v;` thì nó chuyển sang gía trị khác là số dương nhưng số bit vẫn giữ nguyên. Vậy bằng chứng nào mà tôi dám nói số bit giữ nguyên? tôi sẽ chứng minh nó. Ở đây sách đã cho output và đoạn mã, tôi sẽ thử thực thi lại xem ra output terminal và chứng minh nó :

> phần chứng minh, nó có thể hơi ngoài lề bạn có thể bỏ qua

<details>
	<summary>Chứng minh</summary>

code của tôi lấy cảm hứng ví dụ như trong code minh họa CS:APP cung cấp :

```c
#include <stdio.h>

int main(void){

	short int v = -12345;
 	unsigned short uv = (unsigned short) v; // code y nguyên như trong sách 
	printf("v = %d, uv = %u\n", v, uv);

	return 0;
}
```

> gcc -o test_type test_type.c

![alt text](image17.png)

Như trong ảnh, output đã chính xác như sách đưa. Vậy tới phần chứng minh là binary có phải giữ nguyên như tôi nói không, hay các lý thuyết như trong sách có vận hành đúng không tôi sẽ chứng minh nó bằng cách dịch số nguyên không dấu sang nhị phân và thực hiện tính toán :

> echo "obase=2; $((53191))" | bc

![alt text](image18.png)

số nhị phân là `1100111111000111` 16 bit đúng type của short là 2 byte, giờ tới phần tính toán số có dấu xem kết quả tính toán có đúng như tôi nói là số nhị phân giữ nguyên ko nhé :

tính toán bit có dấu signed 

| vị trí bit | 15 | 14 | 13 | 12 | 11 | 10 | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
|------------|----|----|----|----|----|----|---|---|---|---|---|---|---|---|---|---|
| số bit     | 1  | 1  | 0  | 0  | 1  | 1  | 1 | 1 | 1 | 1 | 0 | 0 | 0 | 1 | 1 | 1 |
| value = 2**N | -32768 | 16384 | bỏ | bỏ | 2048 | 1024 | 512 | 256 | 128 | 64 | bỏ | bỏ | bỏ | 4 | 2 | 1 |

từ value trên bảng cộng tổng lại : `(-32768) + 16384 + 2048 + 1024 + 512 + 256 + 128 + 64 + 4 + 2 + 1 = -12345`

![alt text](image19.png)

kết quả ra `-12345` chính xác với kết quả mà CSAPP cho. Suy ra, kết luận của tôi `binary giữ nguyên` là đúng

![alt text](image20.png)

Hãy thử tính nó bằng T2U và U2T 

> nếu bạn cần tìm hiểu thêm về T2U và U2T thì có thể đọc

<details>
<summary>T2U và U2T</summary>

![alt text](image21.png)

Trong CSAPP có đề cập tới hai khái niệm này vậy tôi cần biết nó là gì đã. Ở đây, T2U có nghĩa là chuyển số có dấu signed sang số không dấu unsigned ở đây chúng ta cũng vận dụng luôn cái này vào phần mà tôi đang chứng minh, trước hết ta có biểu thức của T2U là:

> [!NOTE]
> Nếu $x < 0$ thì `x + 2**N`  
> Nếu $x \ge 0$ thì vẫn giữ nguyên $x$

Trong đó $x$ là giá trị số nguyên, $N$ là số bit, `2**N` là biểu thức tính giá trị toàn diện bit ví dụ 4 bit nó sẽ tính `1111` là bao nhiêu. Nói sơ qua thì T2U chủ yếu covert cái số có dấu (signed) sang không dấu (unsigned) điển hình là số âm sang số dương, nếu số âm thì nó sẽ chuyển đổi còn nếu số dương thì nó giữ nguyên gồm cả 0.

Số bit của short như tôi đề cập là 16-bit, vậy tôi biết số có dấu Tmin của cái 16-bit này là $-2^{(N - 1)} = -32768$. Do $-32768$ hoàn toàn bé hơn $0$ nên bây giờ tôi muốn chuyển chúng sang hệ không dấu unsigned thì tôi dùng biểu thức T2U:

$$(-32768) + 2^{16} = 32768$$

> [!WARNING]
> Còn nếu mà số nguyên như 100 lớn hơn 0 thì giữ nguyên, không tính. Nó sẽ là kết quả bị sai dù covert đúng hay không nhưng về bản chất là sai hoàn toàn, không phải vì biểu thức sai mà vì điều kiện không cho phép áp dụng biểu thức với điều đó.

Vậy ví dụ tôi thử tính xem chuyện gì xảy ra biết rõ ràng 100 lớn hơn 0, điều kiện không cho phép vậy tôi vẫn cứ tính xem có gì?

$$100 + 2^{16} = 65636$$ *(Kết quả bị sai dù covert đúng)*

![alt text](image22.png)

Bạn thấy số đã chuyển sang số không dấu unsigned hoàn toàn.

Còn U2T thì ngược lại thôi, nó chuyển unsigned sang signed công thức của nó là:

Nếu $x < 2^{(N-1)}$ thì giữ nguyên.  
Nếu $x \ge 2^{(N-1)}$ thì $x - 2^N$.

Trong đó $x$ là số bit, nếu như $x$ mà nhỏ hơn Tmax của binary thì giữ nguyên, còn nếu $x$ mà lớn hơn Tmax của binary thì dùng công thức U2T. Ví dụ với cái bit như trên là 16-bit đi:

Ở đây cho $x = 32768$, $32768$ hoàn toàn bằng với $2^{(N-1)} = 2^{(16-1)} = 32768$, lúc này ta mới dùng biểu thức U2T:

$$32768 - 2^{16} = -32768$$ *(Bạn thấy nó đã covert sang âm)*

Còn nếu mà tôi dùng số nguyên bé hơn Tmax của binary thì không được, ví dụ tôi có số nguyên là 100 bé hơn $2^{(N-1)} = 2^{(16-1)} = 32768$ thì thử tính:

$$100 - 2^{16} = -65436$$ *(Rõ ràng là sai hoàn toàn dù vẫn là convert nhưng kết quả nó bị sai)*

Nên là hai cái U2T và T2U đều có điều kiện rõ ràng mới có thể tính ra kết quả chính xác được.

![alt text](image23.png)

Bạn thấy nó đã chuyển lại sang âm rồi, vậy tôi cũng đang thắc mắc là chúng ta có thể thêm âm thủ công được mà? cần gì tới mấy công thức này cho rườm rà, vậy mục đích của CSAPP muốn dạy chúng ta là mấy biểu thức này và liệu nó có tác dụng gì?

</details>

</details>

từ đó cũng như thế thôi, bit nhị phân vẫn y nguyên là nó. Cách đọc mới quyết định giá trị của nó là gì và chính cách đọc mới thay đổi, chúng ta có thể chuyển đổi được cách đọc bởi vì nhị phân đã đổi đâu? nên đọc một đoạn mã đó vẫn có thể thây đổi được
