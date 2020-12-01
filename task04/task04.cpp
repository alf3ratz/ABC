#include <iostream>
#include<vector>
#include<thread>
#include<mutex>
#include<string>
#include<omp.h>


/*
Класс, реализующий бойцов турнира.
*/
class Fighter {
public:
	int power;
	std::string team;
	int number;
	Fighter() = default;
	Fighter(int power_, std::string team_, int number_) {
		power = power_;
		team = team_;
		number = number_;
	}
};

Fighter** Tree; //Матрица команд.
Fighter* inputArr; //Входной массив энергии Ци.
int switcher;

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
void makeArrays(double counter) {
	int count = (int)counter;
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
		if (switcher == 0) {
			while (num == -1) {
				std::cout << ">" << ++number << " = ";
				num = check();
				number = i;
			}
		}
		else
			num = std::rand() % 100;
		inputArr[i] = Fighter(num, "First team", i + 1);
		num = -1;
	}
	std::cout << "Input element of the second team:\n";
	for (size_t i = 0; i < count; i++) {
		number = i;
		if (switcher == 0) {
			while (num == -1) {
				std::cout << ">" << ++number << " = ";
				num = check();
				number = i;
			}
		}
		else
			num = std::rand() % 100;
		inputArr[count + i] = Fighter(num, "Second team", i + 1);
		num = -1;
	}
	for (size_t i = 0; i < count; i++)
		Tree[0][i] = inputArr[i];
	for (size_t i = 0; i < count; i++)
		Tree[1][i] = inputArr[i + count];
	std::cout << "The chempionship is going...\n";
}
/*
Реализация задачи о пути Кулака.
*/
void tempWayOfFist(Fighter** matrix, int count) {
	if (count % 2 == 1 && count != 1) {//Первые бои при нечетном числе бойцов в команде, чтоб выравнять сетку игроков.
		Fighter temp;
		matrix[0][count - 1].power > matrix[1][count - 1].power ? temp = matrix[0][count - 1] : temp = matrix[1][count - 1];
		matrix[0][count - 2].power > matrix[1][count - 2].power ? matrix[1][count - 2] = temp : matrix[0][count - 2] = temp;
		--count;
	}
	for (int i = 0; i < count; i++)
	{
		int one = matrix[0][i].number;
		int two = matrix[1][i].number;
		std::string teamOne = matrix[0][i].team;
		std::string teamTwo = matrix[1][i].team;
		std::string powerOne = std::to_string(matrix[0][i].power);
		std::string powerTwo = std::to_string(matrix[1][i].power);
		matrix[0][i].power > matrix[1][i].power ? matrix[1][i] = Fighter(-1, "", -1) : matrix[0][i] = Fighter(-1, "", -1);
		if (matrix[0][i].number == -1)
			std::cout << "The " << std::to_string(two) << "'s fighter(" << powerTwo << ") of the " << teamTwo << " beat the " << std::to_string(one) << "'s fighter(" << powerOne << ") of the " << teamOne << "!\n";
		else
			std::cout << "The " << std::to_string(one) << "'s fighter(" << powerOne << ") of the " << teamOne << " beat the " << std::to_string(two) << "'s fighter(" << powerTwo << ") of the " << teamTwo << "!\n";

	}
	for (int j = 0; j < count; j++)
	{
		if (matrix[0][j].team == "")
			matrix[0][j] = matrix[1][j];
	}
	count /= 2;
	if (count == 0) {
		return;
	}
	for (int j = 0; j < count; j++)
	{
		matrix[1][j] = matrix[0][j + count];
	}
}




std::string wayOfFist(int count) {
	omp_set_dynamic(0);
	Fighter** matrix;
	matrix = new Fighter * [2];
	for (int i = 0; i < 2; i++)
	{
		matrix[i] = new Fighter[count];
	}
	matrix = Tree;
	if (Tree == nullptr)
		return "bad result";
	tempWayOfFist(matrix, count);
	int num = (count) / 2;
	bool check = false;
#pragma omp parallel 
	{
		for (int i = 0; i < num;++i)
		{
			if (check)
				break;
			count /= 2;
#pragma omp single
			{
				if (count % 2 == 1 && count != 1) {//Первые бои при нечетном числе бойцов в команде, чтоб выравнять сетку игроков.
					Fighter temp;
					matrix[0][count - 1].power > matrix[1][count - 1].power ? temp = matrix[0][count - 1] : temp = matrix[1][count - 1];
					matrix[0][count - 2].power > matrix[1][count - 2].power ? matrix[1][count - 2] = temp : matrix[0][count - 2] = temp;
					--count;
				}
				for (int i = 0; i < count; i++)
				{
					int one = matrix[0][i].number;
					int two = matrix[1][i].number;
					std::string teamOne = matrix[0][i].team;
					std::string teamTwo = matrix[1][i].team;
					std::string powerOne = std::to_string(matrix[0][i].power);
					std::string powerTwo = std::to_string(matrix[1][i].power);
					matrix[0][i].power > matrix[1][i].power ? matrix[1][i] = Fighter(-1, "", -1) : matrix[0][i] = Fighter(-1, "", -1);
					if (matrix[0][i].number == -1)
						std::cout << "The " << std::to_string(two) << "'s fighter(" << powerTwo << ") of the " << teamTwo << " beat the " << std::to_string(one) << "'s fighter(" << powerOne << ") of the " << teamOne << "!\n";
					else
						std::cout << "The " << std::to_string(one) << "'s fighter(" << powerOne << ") of the " << teamOne << " beat the " << std::to_string(two) << "'s fighter(" << powerTwo << ") of the " << teamTwo << "!\n";

				}
				for (int j = 0; j < count; j++)
				{
					if (matrix[0][j].team == "")
						matrix[0][j] = matrix[1][j];
				}
				int middle = count / 2;
				if (middle == 0) {
					check = true;;
				}
				for (int j = 0; j < middle; j++)
				{
					matrix[1][j] = matrix[0][j + middle];
				}
			}
		}
	}
	return "The " + std::to_string(matrix[0][0].number) + "th of the " + matrix[0][0].team;
}

int main()
{
	clock_t start_time = clock();
	double count = -1;
	std::string res;
		while (count == -1) {
			std::cout << "Input both teams size:\n";
			count = check(); //Просим ввести размер команды.
		}
		makeArrays(count);
		res = wayOfFist(count);
	std::cout << res << " won!\n";
	return 0;

}
