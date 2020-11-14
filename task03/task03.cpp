#include <iostream>
#include<vector>
#include<thread>
#include<mutex>
#include<string>

/*
Класс, реализующий бойцов турнира.
*/
class Fighter {
public:
	int power;
	std::string team;
	Fighter() {}
	Fighter(int power_, std::string team_) {
		power = power_;
		team = team_;
	}
};

Fighter** Tree; //Матрица команд.
std::recursive_mutex rmtx; //Мьютекс, для регуляции потоков.
Fighter* inputArr; //Входной массив энергии Ци.


/*
Метод, проверяющий корректность данных матрицы.
*/
int check() {
	int count;
	std::string str;
	try
	{
		std::cin >> str;
		count = std::stoi(str);
		if (count <= 0) {
			std::cout << "Wrong input! Please, try again!\n";
			return -1;
		}
	}
	catch (const std::exception&)
	{
		std::cout << "Wrong input! Please, try again!\n";
		return -1;
	}
	return count;
}

/*
Метод, заполняющие нашу матрицу команд.
*/
void makeArrays(int count) {
	rmtx.lock();
	int  num = -1;
	int number;
	std::string str = " ";
	inputArr = new Fighter[count * 2];
	Tree = new Fighter * [2];
	for (size_t i = 0; i < 2; i++)
	{
		Tree[i] = new Fighter[count];
	}

	std::cout << "Input element of the first team:\n";
	for (size_t i = 0; i < count; i++) {
		number = i;
		while (num == -1) {
			std::cout << ">" << ++number << " = ";
			num = check();
			number = i;
		}
		inputArr[i] = Fighter(num, "First team");
		num = -1;
	}
	std::cout << "Input element of the second team:\n";
	for (size_t i = 0; i < count; i++) {
		number = i;
		while (num == -1) {
			std::cout << ">" << ++number << " = ";
			num = check();
			number = i;
		}
		inputArr[count + i] = Fighter(num, "Second team");
		num = -1;
	}
	for (size_t i = 0; i < count; i++)
		Tree[0][i] = inputArr[i];
	for (size_t i = 0; i < count; i++)
		Tree[1][i] = inputArr[i + count];
	std::cout << "The chempionship is going...\n";
	rmtx.unlock();
}
/*
Реализация задачи о пути Кулака.
*/
std::string wayOfFist(int count) {
	rmtx.lock();
	if (Tree == nullptr)
		return "bad result";
	if (count % 2 == 1 && count != 1) {//Первые бои при нечетном числе бойцов в команде, чтоб выравнять сетку игроков.
		Fighter temp;
		Tree[0][count - 1].power > Tree[1][count - 1].power ? temp = Tree[0][count - 1] : temp = Tree[1][count - 1];
		Tree[0][count - 2].power > Tree[1][count - 2].power ? Tree[1][count - 2] = temp : Tree[0][count - 2] = temp;
		--count;
	}
	for (size_t i = 0; i < count; i++)
	{
		Tree[0][i].power > Tree[1][i].power ? Tree[1][i] = Fighter(-1, "") : Tree[0][i] = Fighter(-1, "");
	}
	for (size_t i = 0; i < count; i++)
	{
		if (Tree[0][i].team == "")
			Tree[0][i] = Tree[1][i];
	}
	int middle = count / 2;
	if (middle == 0) {
		rmtx.unlock();
		return Tree[0][0].team;
	}
	for (size_t i = 0; i < middle; i++)
	{
		Tree[1][i] = Tree[0][i + middle];
	}
	std::string res;//Новый поток для осуществления раундов.
	std::thread thr_([&res, &count]() {res = wayOfFist(count / 2);});
	rmtx.unlock();
	thr_.join();
	return res;
}

int main()
{
	std::string str;
	int count = -1;
	while (count == -1) {
		std::cout << "Input both teams size:\n";
		count = check(); //Просим ввести размер команды.
	}
	std::string res;
	std::thread thOne(makeArrays, count); // Создание первого потока.
	std::thread thTwo([&res, &count]() {res = wayOfFist(count);}); //Создание второго потока.
	thOne.join();
	thTwo.join();
	std::cout << res << " won!";
	return 0;

}
