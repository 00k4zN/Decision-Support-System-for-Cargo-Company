<h1>SUMMARY</h1>

A decision support system has been developed to identify the priority branches to be closed in case of downsizing in accordance with the needs of OPS Cargo Company. Additionally, in order to improve staff productivity, the tracking of performance scores given and the identification and closer examination of employees who lower the average performance score (5.0) have also been targeted. Furthermore, access to branch vehicle information can be obtained through the prepared dashboard.
---

<h1>INTRODUCTION</h1>

The project structure has been planned, designed, and executed with a forward-looking perspective. It has been prepared as a middle-level management decision support system. In OPS Cargo, the middle-level manager is the regional director of the company. The regional director can track the current status and future potential situations of the districts within their responsibility through the prepared dashboard and take actions accordingly. Each page on the dashboard provides detailed information to the manager about branch-related matters such as personnel status and vehicle status, using both tables and graphs to facilitate decision-making. The manager panel includes an interactive line graph showing the annual income and expenses of the branches and a pie chart displaying the annual profit/loss situation of each branch. At the top of the manager panel page, there are cards displaying 'Total Branch Count,' 'Total Personnel Count,' 'Total Vehicle Count,' and 'Annual Total Profit.' The manager can view general information about the branches in real-time from here.
---


<h1>SECTION - 1</h1>

OPS Cargo company aims to use the Cargo Decision Support System to eliminate costs and losses in the event of downsizing. In this scenario, when the company intends to close branches, it examines all of its branches on a provincial basis. The examination process is carried out by the regional directors responsible for each province. In the prepared decision support system, the profit or loss level achieved by each branch in the previous year is taken as a basis. In this way, it is possible to identify the branch that incurred the highest losses in that year based on past year's data. The representation of the mentioned data on the dashboard is as follows:
---
![image1](https://github.com/00k4zN/Decision-Support-System-for-Cargo-Company/blob/main/Images/image1.png)


The manager can make decisions regarding both branches and personnel, along with taking certain actions. The company uses the performance score parameter to measure the productivity of employees. For example, the efficiency scores of employees working in a branch are determined by the branch manager. Branch managers, on the other hand, receive their scores from the regional directors. In addition to this, a reward-incentive model has been implemented, where branch managers who make customer agreements, the total number of these agreements, and how many agreements each manager has made are tracked. At the end of the year, the manager who has signed the most agreements is identified and rewarded.
---
![image2](https://github.com/00k4zN/Decision-Support-System-for-Cargo-Company/blob/main/Images/image2.png)


The criterion that the company relies on for employee productivity is reflected as the performance score on the dashboard. The company aims to maintain an average employee score above 5.0 and, to achieve this, it identifies and keeps track of employees who lower the average score. Employees who remain on the tracking list for an extended period are terminated from their positions. This way, by cutting ties with inefficient workers, the company can make some improvements in its overall efficiency.
---
![image3](https://github.com/00k4zN/Decision-Support-System-for-Cargo-Company/blob/main/Images/image3.png)


Another page on the dashboard is the "Vehicles" page, where the vehicles belonging to branches are listed and examined. On this screen, the vehicles used by each branch, their makes and models, types, and annual total vehicle maintenance expenses are displayed. The most frequently preferred vehicle model among the available vehicles is indicated in the cards at the top of the screen. This information can be considered when making decisions about vehicle purchases, enabling bulk vehicle purchases to be made accordingly.

In addition to this, the cargo capacity of the existing vehicles is also taken into account. You can access information about the model of the vehicle with the largest and the smallest cargo capacity from this screen.
---
![image4](https://github.com/00k4zN/Decision-Support-System-for-Cargo-Company/blob/main/Images/image4.png)

Finally, when a manager wants to open a new branch, they can add a new branch from the "Add" screen at the bottom of the sidebar.
---
![image5](https://github.com/00k4zN/Decision-Support-System-for-Cargo-Company/blob/main/Images/image5.png)


<h1>SECTION - 2</h1>

The project primarily employed a quantitative research methodology. The information and analyses required for a cargo operation were created using numerical data and presented to the management. The data that middle-level managers most needed for making semi-structured and non-structured decisions were expressed through tables and graphs. The prepared dashboard is user-friendly and interactive, designed to enable middle-level managers to use it with little or no assistance from a Management Information Systems Specialist.

The Cargo Decision Support System project is primarily designed for strategic and tactical-level managers, providing decision support and facilitating cross-level integration when needed.

During the software development process of the project, the Waterfall Model was utilized. In the Waterfall method, the software development process consists of stages such as analysis, design, coding, testing, release, and maintenance. In traditional software methodologies, these stages proceed linearly, similar to the cascade model.
---
![image6](https://github.com/00k4zN/Decision-Support-System-for-Cargo-Company/blob/main/Images/image6.png)

At the final stage, the Dashboard screenshot is as follows:
---
![image7](https://github.com/00k4zN/Decision-Support-System-for-Cargo-Company/blob/main/Images/image7.png)

![image8](https://github.com/00k4zN/Decision-Support-System-for-Cargo-Company/blob/main/Images/image8.png)

![image9](https://github.com/00k4zN/Decision-Support-System-for-Cargo-Company/blob/main/Images/image9.png)

![image11](https://github.com/00k4zN/Decision-Support-System-for-Cargo-Company/blob/main/Images/image11.png)


<h1>SECTION - 3</h1>

In the initial phase, a MySQL database was chosen for the database setup. The interaction between tables and diagrams has been created as follows:
---
![image12](https://github.com/00k4zN/Decision-Support-System-for-Cargo-Company/blob/main/Images/image12.png)

The used triggers are as follows:
---
![image13](https://github.com/00k4zN/Decision-Support-System-for-Cargo-Company/blob/main/Images/image13.png)

An example of a trigger that ensures that the first letter of the employee's name is capitalized while the remaining letters are in lowercase when recording employee data.
---
![image14](https://github.com/00k4zN/Decision-Support-System-for-Cargo-Company/blob/main/Images/image14.png)

An example of a trigger that ensures that all letters of the entered employee's last name are capitalized when recording employee data.
---
![image15](https://github.com/00k4zN/Decision-Support-System-for-Cargo-Company/blob/main/Images/image15.png)

An example of a trigger that automatically adds information about deleted personnel to a table named 'blacklist'.
---
![image16](https://github.com/00k4zN/Decision-Support-System-for-Cargo-Company/blob/main/Images/image16.png)




<h1>Technologies Used in the Project:</h1>
---
<p>Software/Tools:</p> Microsoft VS Code, WampServer64
<p>Web Server:</p> Apache 2.4.46
<p>Programming Languages:</p> PHP, JavaScript, SQL
<p>Markup Languages:</p> HTML5, CSS3
<p>Database/Database Management Software:</p> MySQL/PhpMyAdmin
