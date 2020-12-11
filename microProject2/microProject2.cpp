#include <iostream>
#include <ctime>
#include<thread>
#include<mutex>
#include<string>
#include<chrono>
#include<windows.h>

bool isSleep = true;
std::mutex mtx_bees;
std::mutex mtx_bear;//Мьютексы для правильной работы программы
int N;	//Число капель в горшке.
int n;  // Число пчел.
int numberOfRounds;	// Кол-во наполнений горшка с мёдом.
int iterator;	// Число характеризующее кол-во наполненных горшоков. (сколько раз программа отработала).
int countOfHoney;	//Число капель, находящихся в горшке.
int checker;	//Переменная, для проверки в начале программы.
int switcher;	//Переменная, для работы с вводом значений в начале программы.

/*
Метод, осуществляюший работу медведя (опустошение горшка с мёдом).
*/
void bearAndBees() {
	while (true) {
		mtx_bear.lock();
		if (countOfHoney == 0) {
			mtx_bear.unlock();
			return;
		}
		if (iterator > numberOfRounds) {
			mtx_bear.unlock();
			return;
		}
		if (countOfHoney == N) {
			isSleep = true;
			std::cout << "Медведь проснулся!\n";
			iterator++;
			countOfHoney = 0;
		}
		mtx_bear.unlock();
	}
}

/*
Метод, осуществляющий добавление капель в горшок с медом.
*/
void addToPot(void* i) {
	int num = *((int*)i);
	while (countOfHoney < N) {
		mtx_bees.lock();
		if (countOfHoney >= N) {
			mtx_bees.unlock();
			continue;
		}
		if (iterator > numberOfRounds) {
			mtx_bees.unlock();
			return;
		}
		countOfHoney++;
		std::cout << std::to_string(num) + "ая пчела положила " + std::to_string(countOfHoney) + "ую каплю! \n";
		if (countOfHoney == N) {
			std::cout << "Горшок наполнен " + std::to_string(num) + "ой пчелой!\n";
			bearAndBees();
			isSleep = false;
		}
		mtx_bees.unlock();
		Sleep(1000);
	}
}
/*
Метод правильного ввода для кол-ва повторений программы.
*/
int tryParseForBear() {
	int count;
	std::string str;
	try
	{
		std::cin >> str;
		count = std::stoi(str);
		if (count < 0) {
			std::cout << "Неправильный ввод, попробуйте еще раз!\n";
			return -1;
		}
	}
	catch (const std::exception&)
	{
		std::cout << "Неправильный ввод, попробуйте еще раз!\n";
		return -1;
	}
	return count;
}

/*
Метод, осуществляющий проверку взодных данных.
*/
int tryParse() {
	int count;
	std::string str;
	try
	{
		std::cin >> str;
		count = std::stoi(str);
		if (count <= 0 && checker == 1) {
			std::cout << "Неправильный ввод, попробуйте еще раз!\n";
			return -1;
		}
		else if (count == 0) {
			checker++;
			return count;
		}
	}
	catch (const std::exception&)
	{
		std::cout << "Неправильный ввод, попробуйте еще раз!\n";
		return -1;
	}
	return count;
}

int main() {
	setlocale(LC_ALL, "ru");
	std::cout << "Введите 0, если ходите задать значения вручную или введите 1, если хотите, чтобы все задалось автоматически:\n";
	switcher = -1;
	checker = 0;
	while (switcher == -1 || switcher < 0 || switcher>1)
	{
		std::cout << "Введите число...\n";
		switcher = tryParse();
	}
	int temp = switcher;
	n = -1;
	N = -1;
	numberOfRounds = -1;
	if (temp == 0)
	{
		std::cout << "Введите число пчел:\n";
		while (n == -1)
			n = tryParse();
		std::cout << "Введите число глотков:\n";
		while (N == -1)
			N = tryParse();
		std::cout << "Введите число пробуждений медведя:\n";
		while (numberOfRounds == -1)
			numberOfRounds = tryParseForBear();
	}
	else {
		srand(time(0));
		n = rand() % 100;
		N = rand() % 1000;
		numberOfRounds = 1 + rand() % 7;
		std::cout << "Кол-во пчел: " << n << std::endl;
		std::cout << "Кол-во глотков: " << N << std::endl;
		std::cout << "Кол-во итераций по программе: " << numberOfRounds << std::endl;
	}
	countOfHoney = 0;
	iterator = 0;
	std::thread* bees = new std::thread[n];
	std::thread thr1(bearAndBees);
	int* bs = new int[n];
	for (size_t i = 0; i < n; i++)
	{
		bs[i] = i + 1;
		//bees[i] = std::thread([&i,&bs]() {addToPot((void*)(bs + i));});
		bees[i] = std::thread(addToPot, (void*)(bs + i));
	}
	thr1.join();
	for (size_t i = 0; i < n; i++)
	{
		bees[i].join();
	}
	delete[] bees;
	return 0;
}