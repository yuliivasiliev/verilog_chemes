module test;
    reg clk, rst,apply;
    reg [7:0] in;
    reg [2:0] op;
    main testing(.clk(clk), .rst(rst), .apply(apply), .in(in), .op(op));
    initial begin
        $dumpfile("main.vcd");
        $dumpvars(0, test);
        #90 $finish;
    end

    initial begin
        clk = 1;
        rst = 0;
        apply = 0;
    end

    always #1 clk = !clk;
    initial begin
        #2 rst = 1;
        #1 rst = 0;
    end

    // Добавление чисел в очередь
    initial begin
         #1 
         in = 8'd35; // в 16й число "23"
         op = 3'd0;  // Добавление
         #2 
         apply = 1;  // Подтверждаем операцию
         #12         // Вставляем 6 чисел
         apply = 0;
         op = 3'd2;  // Сложение
         #2 
         apply = 1;  // Подтверждаем операцию (останется 5 чисел): 70 35 35 35 35
         #2
         apply = 0;
         op = 3'd3;  // Вычитание
         #2 
         apply = 1;  // Подтверждаем операцию (останется 4 числа) 0 70 35 35 
         #2
         apply = 0;
         op = 3'd4;  // Произведение
         #2 
         apply = 1;  // Подтверждаем операцию (останется 3 числа) 201 0 70
         #2
         apply = 0;
         op = 3'd5;  // Деление целое
         #2 
         apply = 1;  // Подтверждаем операцию (останется 2 числа) 0 201
         #2
         apply = 0;
         op = 3'd5;  // Деление остаточное
         #2 
         apply = 1;  // Подтверждаем операцию (останется 1 число) 0
         #2 
         apply = 0;
         op = 3'd1;  // Удаляем оставшийся 0
         #2
         apply = 1;  // Подтверждаем операцию (пусто)
         #4          // Вызовем ошибку удаления элемента
         rst = 1;    // Сбросим всё
         apply = 0;
         #1 
         rst = 0;    // Восстановим
         #1 
         in = 8'd11; // в 16й число "0B"
         op = 3'd0;  // Добавление
         #2          // Вызовем ошибку переполнения
         apply = 1;  // Подтверждаем операцию
         #22         // Вставляем 11 чисел
         rst = 1;    // Сбросим всё
         apply = 0;
         #1 
         rst = 0;    // Восстановим
         op = 3'd7;  // Некорректная операция
         #2          // Вызовем ошибку кода операции
         apply = 1;  // Подтверждаем операцию

         #4          // Вызовем ошибку удаления элемента
         rst = 1;    // Сбросим всё
         apply = 0;
         #2
         rst = 0;    // Восстановим
         in = 8'd0;  // Добавим 2 нуля
         op = 3'd0;  // Добавление
         #2
         apply = 1;  // Подтверждаем операцию
         #4
         apply = 0;
         #2
         op = 3'd6;
         #2
         apply = 1;  // Поделим и получим ошибку деления на ноль
         #4
         rst = 1;    // Сбросим всё
         apply = 0;
         #1 
         rst = 0;    // Восстановим
    end

endmodule